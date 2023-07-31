# Slope One Algorithm in PySpark

Brendan Hawk  
2022-06-21  

## Overview

In this project, the Slope One Algorithm[^1] is implemented using PySpark, and applied to the MovieLens dataset in order to predict user ratings. Slope One is a collaborative filtering algorithm that does not require higher order matrix mathematics often necessary to perform this work with other approaches like PCA or SVD.

## Running the project
The easiest way to run and learn from this project is the included [Jupyter Notebook](SlopeOneAlgorithmInSpark.ipynb). This file also includes an explanation of the problem being solved and the Slope One alorithm itself.

If you'd like to run the script the way you would in a cloud computing setting, or would like to run it in an actual cloud setting (eg GCP), the included python file [SlopeOne.py](SlopeOne.py) performs the same analysis with the same code, without print statements or other unneeded additions. The python script is slightly configurable at runtime: you need to specify a file path (such as a google storage URL) as the first argument, and optionally you may include a second argument as a single decimal number representing the portion of data to be used as test data (the default is 0.2).

## Data
The data used for this project is from the [GroupLens publications](https://grouplens.org/datasets/movielens)[^2] of data from the [MovieLens website](https://movielens.org). Three datasets were used in development of this project: "Latest-Small", which contains 100,000 ratings, "Latest" which contains ~27 million ratings, and an older version known as "10M", which contains 10 million ratings. All data can be accessed from the GroupLens website.

Once downloaded from the source, the `latest-small` and `latest` datasets are published in standard CSV format. For this project, the first line of each file (the header) was removed using the following commands:

```
tail -n +2 ratings.csv > ratings_noheader.csv
mv ratings_noheader.csv ratings.csv
```

The `10M` dataset is an older publication, and is in a format that uses `::` as its delimiter and does not include a header. This was converted to standard CSV format using the following command:

```
sed 's/::/,/g' ratings.dat > ratings.csv
```

All files were then compressed using `bzip2`.


### Citations

[^1]: Lemire, Daniel and Maclachlan, Anna (2007). Slope One Predictors for Online Rating-Based Collaborative Filtering. https://doi.org/10.48550/arXiv.cs/0702144

[^2]: F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets: History and Context. ACM Transactions on Interactive Intelligent Systems (TiiS) 5, 4: 19:1–19:19. https://doi.org/10.1145/2827872