#!/bin/bash

### Variables ###
CLOUD_PROVIDER_NAME=$1
MASTER_URL=$2
ENV_TYPE=$3
APP_NAME=$4
INPUT_SERVICE=$5
PROD_NAMESPACE=$6
TEST_NAMESPACE=$7

### MAIN ###


echo "USAGE: <Application_name> <MASTER_URL_PROD> <MASTER_URL_TEST> <SERVICE_TYPE> <Service_Name> <PROD_NAMESPACE> <TEST_NAMESPACE>"

# Axe CP_Name, ENV_TYPE, 
# ASk for kubernetes or Helm
# Service_Name, Service_Helm, Service_K8, 
if [ $# -lt 7 ]; then
echo "ERROR: Not enough arguments"
echo "USAGE: <CLOUD_PROVIDER_NAME> <MASTER_URL> <ENV_TYPE> <APP_NAME> <INPUT_SERVICE> <PROD_NAMESPACE> <TEST_NAMESPACE>"
exit 0
fi

echo "INFO: Creating Cloud Provider"
echo "INFO: Running Cloud Provider Script"
./cloud_provider_generator.sh $1 $2 $3 

sleep 5 


echo "INFO: Creating the Application"
echo "INFO: Running Application automation script"
./automation.sh $4 $5 $6 $7

sleep 5

./edit_cloud_provider.sh $1 $2 $4 $3

echo "INFO: DONE"

