#! /bin/bash
# Waiting till the checkpoint is captured correctly
while true
do 
    echo Waiting till the checkpoint is captured correctly...
    if ([ -f /opt/logs/snapshot.log ]) && (grep -Fxq "Command executed successfully" "/opt/logs/snapshot.log")
    then
	    echo Checkpoint captured!
	    break
    fi
    sleep 5
done