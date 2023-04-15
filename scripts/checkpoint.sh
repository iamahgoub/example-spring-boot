#! /bin/bash

# pre-requisites
apt-get --assume-yes install siege -y
# start the application
echo Starting the application...
cd /opt/app
nohup java -XX:CRaCCheckpointTo=/opt/crac-files -jar spring-boot-initial-0.0.1-SNAPSHOT.jar &

# ensure the application started successfully
echo Confirming the application started successfully...
sleep 5
echo nohup.out

# warm up the application
echo Warming up the application...
siege -c 1 -r 10 -b http://localhost:8080
sleep 10

# request a checkpoint
echo Taking a snapshot of the application using CRaC...
mkdir /opt/logs/
jcmd spring-boot-initial-0.0.1-SNAPSHOT.jar JDK.checkpoint >> /opt/logs/snapshot.log

# the code below is to keep the container running indefinitely
echo Executing an infinite loop to keep the container running...
while true; do sleep 1; done