#!/bin/bash

CLOUD_PROVIDER_NAME=""
MASTER_URL=""
SERVICE_ACCOUNT="changeMe"
ENV_TYPE=""
APP_NAME=""



fn_cloud_provider_prod(){
cd Setup/Cloud\ Providers/

echo "INFO: serviceAccount input"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'serviceAccountToken' $SERVICE_ACCOUNT --inplace

echo "INFO: masterUrl input"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'masterUrl' $MASTER_URL --inplace

echo "INFO: Selecting the application to scope to the cloud provider"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'usageRestrictions.appEnvRestrictions.[0].appFilter.entityNames[0]' $APP_NAME --inplace

echo "INFO: Cloud Provider Environment Scoping Restrictions for the application"
echo "OPTIONS: PROD or NON_PROD"

if ["$ENV_TYPE" == "PROD"] || ["$ENV_TYPE" == "NON_PROD"]; then
    yq w $CLOUD_PROVIDER_NAME-prod.yaml 'usageRestrictions.appEnvRestrictions.[0].envFilter.filterTypes[0]' $ENV_TYPE --inplace
else
    echo "OPTIONS: PROD or NON_PROD"
fi 
}

fn_summary_creation() {
echo "INFO: Summary of Cloud Provider Creation\n"
cat $CLOUD_PROVIDER_NAME-prod.yaml

}

fn_commit(){
echo "INFO: Adding files to Github commit"
git add -A
echo "Generating the commit"
git commit -m "harness.io script commiting cloud provider changes"

echo "Pushing code to github"
git push
}

### MAIN ####
if [ $# -lt 4 ]; then
echo "ERROR: Not enough arguments"
echo "Usage: ./cloud_provider_generator.sh <CLOUD_PROVIDER_NAME> <MASTER_URL> <APP_NAME> <ENV_TYPE> "
exit 0
fi

if [ -d "Setup" ]; then 
    CLOUD_PROVIDER_NAME=$1
    MASTER_URL=$2
    APP_NAME=$3
    ENV_TYPE=$4
    echo "INFO: Creating Cloud Provider"
    fn_cloud_provider_prod
else 
  echo "ERROR: No Setup Directory Found"
fi

fn_summary_creation
sleep 2
fn_commit