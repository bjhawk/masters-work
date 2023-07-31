import getpass
import pandas as pd
import psycopg2 as pg
from psycopg2.extras import execute_values, DictCursor

# Set up a credential dictionary for database connections
databaseName="SAU_Catch_DB"
databaseUser="postgres"
databasePass = getpass.getpass("Password for user `%s` on database `%s`:".format(databaseName, databaseUser))

# Create some helper functions to make the rest of the script easier to follow
# Creates a database connection and cursor object
def connect_to_database():
    conn = pg.connect(dbname=databaseName, user=databaseUser, password=databasePass)
    return (conn, conn.cursor())

# Leverages a psycopg2.extras helper to do bulk insertions
def bulk_insert(queryString, values, batchSize=100):
    (dbConnection, dbCursor) = connect_to_database()
    execute_values(dbCursor, queryString, values.to_dict("records"),
                   make_values_template(values), batchSize)
    
    dbConnection.commit()
    dbConnection.close()
    
# Helper for the above function to create the template string
# used for each batch of values in a bulk insert operation
def make_values_template(values):
    valuesLength = values.shape[1]
    valuesTemplate = "(" + ",".join(["%({})s"] * valuesLength) + ")"
    valuesTemplate = valuesTemplate.format(*values.columns.to_list())
    return valuesTemplate

# Wrapper for a basic "Fetch All" operation
def select(queryString, queryParams=[]):
    (dbConnection, dbCursor) = connect_to_database()
    dbCursor.execute(queryString, queryParams)
    returnValues = dbCursor.fetchall()
    dbConnection.close()
    return returnValues

# Same as above, but leverages psycopg2.extras DictCursor
# The return values are easier to use when converting to DataFrames
def select_dicts(queryString, queryParams=[]):
    dbConnection = pg.connect(dbname=databaseName, user=databaseUser, password=databasePass)
    dbCursor = dbConnection.cursor(cursor_factory=DictCursor)
    dbCursor.execute(queryString, queryParams)
    returnValues = dbCursor.fetchall()
    dbConnection.close()
    return returnValues