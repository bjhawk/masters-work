from __future__ import print_function

import sys

from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.types import StringType, StructType, StructField, IntegerType, FloatType
from pyspark.sql.functions import avg, col, sum, count

import numpy as np

# First, get the running configuration parsed out
local = True
dataFile = "./Term Project/data/100k.csv.bz2"
test_ratio = 0.2

if len(sys.argv) > 1:
    local = False
    dataFile = sys.argv[1]

if len(sys.argv) == 3:
    test_ratio = float(sys.argv[2])
    
# Create our spark and sparkSQL contexts
conf = SparkConf().setAppName("Slope-One")
if local:
    conf.setMaster("local[*]")

sc = SparkContext(conf=conf)
sparkSql = SparkSession.builder.getOrCreate()

# Read the data
print("Reading data file: {}".format(dataFile))
ratings = sparkSql.read.csv(
    dataFile,
    header=False,
    schema=StructType([
        StructField("userId", IntegerType(), False),
        StructField("movieId", IntegerType(), False),
        StructField("rating", FloatType(), False),
        StructField("timestamp", StringType(), False)
    ])
).select("userId", "movieId", "rating")

train_test_split = [1 - test_ratio, test_ratio]
print("Splitting data [{}, {}]".format(*train_test_split))
(training, test) = ratings.randomSplit(train_test_split, seed=777)
training.cache()

print("Calculating Movie means . . .")
movie_means = training.groupBy("movieId").agg(avg("rating").alias("mean"))

print("Aggregating model data . . .")
model_data_left = training.select(
    "userId",
    col("movieId").alias("movieId1"),
    col("rating").alias("rating1")
)
model_data_right = training.select(
    "userId",
    col("movieId").alias("movieId2"),
    col("rating").alias("rating2")
)
model = (
    model_data_left
    .join(model_data_right, on = "userId", how = "left")
    .filter("movieId1 != movieId2")
    .withColumn("b", col("rating2") - col("rating1"))
    .groupBy("movieId1", "movieId2")
    .agg(sum("b").alias("b"), count("userId").alias("support"))
    .withColumn("b", col("b") / col("support"))
)
model.cache()

# Predictions for test set
print("Preparing to generate test predictions . . .")
prediction_data = (
    test
    .join(movie_means, on="movieId")
    .select(
        col("userId").alias("user_pred"),
        col("movieId").alias("movie_pred"),
        col("rating").alias("rating_true"),
        "mean"
    )
)

training_join = [training.userId == prediction_data.user_pred, training.movieId != prediction_data.movie_pred]
prediction_data = prediction_data.join(training, on=training_join, how="left")

model_join = [model.movieId2 == prediction_data.movie_pred, model.movieId1 == prediction_data.movieId]
prediction_data = prediction_data.join(model, on=model_join, how="left")

predictions = (
    prediction_data
    .groupBy("user_pred", "movie_pred", "rating_true", "mean")
    .agg((sum((col("rating") + col("b")) * col("support")) / sum("support")).alias("rating_pred"))
)

# calculate loss
print("Calculating Loss . . .")
loss = np.array(
    predictions
    .rdd
    .map(lambda p: (p["rating_pred"] - p["rating_true"]) if p["rating_pred"] else (p["mean"] - p["rating_true"]))
    .collect()
)
# RMSE
loss = np.sqrt(np.sum(loss**2) / len(loss))
print("RMSE: {:0.4f}".format(loss))

exit(sc.stop())