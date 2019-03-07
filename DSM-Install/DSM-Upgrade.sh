#!/bin/bash

dsmMajorVersion="11.3"
dsmMinorVersion="184"
dsmVersion="$dsmMajorVersion.$dsmMinorVersion"
workingDir="/tmp/DSM-Upgrade"
logFile="dsm-Upgrade.log"
logFileLocation="$workingDir/$logFile"

#Working Directory/Logging setup
if [ -e $workingDir ]
then
	echo "Working Directory already exists"
else
	mkdir $workingDir
	echo "Working directory created"
fi

if [ -e $logFileLocation ]
then
	echo "Log file already exists"
else
       touch $logFileLocation
       echo "Log file created"
fi


echo "$(date) - DSM upgrade script started" | tee -a $logFileLocation

if [ -e $workingDir/manager-$dsmVersion.sh ]
then
	echo "DSM installer has already been downloaded.  Skipping download"
	echo "$(date) - DSM installer permissions set"  | tee -a $logFileLocation
	chmod +x $workingDir/manager-$dsmVersion.sh
	echo "$(date) - DSM upgrade started"  | tee -a $logFileLocation
	$workingDir/manager-$dsmVersion.sh -q -console
else
	echo "$(date) - Manager installer downloaded to working directory"  | tee -a $logFileLocation
	curl -o $workingDir/manager.sh https://files.trendmicro.com/products/deepsecurity/en/$dsmMajorVersion/Manager-Linux-$dsmVersion.x64.sh
	chmod +x $workingDir/manager-$dsmVersion.sh
	echo "$(date) - DSM upgrade started"  | tee -a $logFileLocation
	$workingDir/manager-$dsmVersion.sh -q -console
fi

echo "$(date) - DSM upgrade script completed" | tee -a $logFileLocation

unset dsmMajorVersion
unset dsmMinorVersion
unset dsmVersion
unset workingDir
unset logFile
unset logFileLocation
