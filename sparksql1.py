
from __future__ import print_function
from pyspark.sql import SparkSession
from pyspark.sql import Row

spark = SparkSession.builder.appName("SparkSQL").getOrCreate()

def mapper(line):
    fields = line.split(',')
    return Row(user_id=int(fields[0]), movie_id=int(fields[1]), rating=float(fields[2]), timestamp=int(fields[3]))

linesRDD = spark.sparkContext.textFile("/usr/src/app/ratings.csv")
ratingsRDD = linesRDD.map(mapper)

schemaRatings = spark.createDataFrame(ratingsRDD).cache()
schemaRatings.createOrReplaceTempView("movie_ratings")

query = "SELECT movie_id, count(rating) as cnt FROM movie_ratings GROUP BY movie_id ORDER BY cnt desc limit 10"
top_rated = spark.sql(query)

outputData = ""
for top_movie in top_rated.collect():
    outputData = outputData + str(top_movie["movie_id"]) + "," + str(top_movie["cnt"]) + "\n"

print(outputData)

