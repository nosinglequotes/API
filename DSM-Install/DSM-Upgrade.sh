#!/bin/bash

dsmMajorVersion="11.3"
dsmMinorVersion="184"
dsmVersion="$dsmMajorVersion.$dsmMinorVersion"
workingDir="/tmp/DSM-Upgrade"
logFile="dsm-Upgrade.log"
logFileLocation="$workingDir/$logFile"

#Working Directory/Logging setup
mkdir $workingDir
touch $workingDir$logFile

echo "$(date) - DSM upgrade script started" | tee -a $logFileLocation
echo "$(date) - Manager installer downloaded to working directory"  | tee -a $logFileLocation
curl -o $workingDir/manager.sh https://files.trendmicro.com/products/deepsecurity/en/$dsmMajorVersion/Manager-Linux-$dsmVersion.x64.sh

echo "$(date) - DSM installer permissions set"  | tee -a $logFileLocation
chmod +x $workingDir/manager.sh

echo "$(date) - DSM upgrade started"  | tee -a $logFileLocation

$workingDir/manager.sh -q -console

echo "$(date) - DSM upgrade script completed" | tee -a $logFileLocation

unset dsmMajorVersion
unset dsmMinorVersion
unset dsmVersion
unset workingDir
unset logFile
unset logFileLocation
