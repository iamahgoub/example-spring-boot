# run java
java -XX:CRaCRestoreFrom=/opt/crac-files

# the code below is to keep the container running if the java process failed 
echo Executing an infinite loop to keep the container running...
while true; do sleep 1; done