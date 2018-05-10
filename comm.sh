#!/bin/bash


if [ ${FILE_TYPE} = "tab" ]
then
    spark-submit /usr/src/app/sparksql.py
else
    spark-submit /usr/src/app/sparksql1.py
fi
