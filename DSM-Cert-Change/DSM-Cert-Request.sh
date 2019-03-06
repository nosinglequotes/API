#!/bin/bash

# This script will output a csr that needs to be signed by your CA.

echo 'Make Backup and Working Directories'
mkdir /opt/dsm/cert-change/
mkdir /opt/dsm/cert-change/backup

echo 'Backup: .keystore, configuration.properties, cacerts'
cp /opt/dsm/.keystore /opt/dsm/cert-change/backup
cp /opt/dsm/configuration.properties /opt/dsm/cert-change/backup
cp /opt/dsm/jre/lib/security/cacerts /opt/dsm/cert-change/backup

echo 'Create new keystore'
/opt/dsm/jre/bin/keytool -genkey -keyalg RSA -keystore /opt/dsm/cert-change/.keystore  -alias tomcat -dname cn=dsm.lab.local -storepass changeit

echo 'Generate CSR'
/opt/dsm/jre/bin/keytool -certreq -keyalg RSA -keystore /opt/dsm/cert-change/.keystore -alias tomcat -file /opt/dsm/cert-change/certrequest.csr -storepass changeit

echo 'Please get /opt/dsm/cert-change/certrequest.csr signed by your CA'
