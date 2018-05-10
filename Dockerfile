FROM java:8-jdk-alpine

# install python 3
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# General dependencies
RUN apk update && \
    apk add curl && \
    apk add bash

# copy input file to app folder
COPY ratings.csv /usr/src/app/
COPY sparksql.py /usr/src/app/
COPY sparksql1.py /usr/src/app/
COPY comm.sh /usr/src/app/


# Setup Environmental variables for spark
ENV SPARK_VERSION 2.3.0
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-hadoop2.7
ENV SPARK_HOME /usr/spark-$SPARK_VERSION
ENV PYSPARK_PYTHON python3
ENV PATH $PATH:$SPARK_HOME/bin

# Install Spark
RUN curl -sL --retry 3 \
    "http://apache.spinellicreations.com/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz" \
    | gunzip \
    | tar x -C /usr/ && \
    mv /usr/$SPARK_PACKAGE $SPARK_HOME && \
    rm -rf $SPARK_HOME/examples $SPARK_HOME/ec2

# give execute permission on shell file
RUN chmod +x /usr/src/app/comm.sh

# set working directory
WORKDIR /$SPARK_HOME

# run the shell file
CMD ["/usr/src/app/comm.sh"]

