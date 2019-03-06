#!/bin/bash

# This cert import script is designed to import a p7b cert file format.

echo 'Import dsm.p7b into cacerts'
/opt/dsm/jre/bin/keytool -import -alias tomcat -trustcacerts -file /opt/dsm/cert-change/dsm.p7b -keystore /opt/dsm/jre/lib/security/cacerts -storepass changeit

echo 'Import dsm.p7b into .keystore'
/opt/dsm/jre/bin/keytool -import -alias tomcat -trustcacerts -file /opt/dsm/cert-change/dsm.p7b -keystore /opt/dsm/cert-change/.keystore -storepass changeit

echo 'Replace .keystore with new .keystore'
cp -rf /opt/dsm/cert-change/.keystore /opt/dsm/.keystore

echo 'Update keystore password'
sed -i 's/keystorePass.*/keystorePass=changeit/' /opt/dsm/configuration.properties

systemctl restart dsm_s
