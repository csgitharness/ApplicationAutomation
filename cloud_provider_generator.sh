#!/bin/bash

CLOUD_PROVIDER_NAME=""
MASTER_URL=""
SERVICE_ACCOUNT="changeMe"
ENV_TYPE=""


#FILE NAME is APPLICATION_ENV

#2 Master URLS for 2 CLoud Provider

fn_cloud_provider(){
cd Setup/Cloud\ Providers/

touch $CLOUD_PROVIDER_NAME-prod.yaml 

cp  Namespace\ dpt\ -\ Prod\ Cluster\ --\ referenceCloudProvider.yaml $CLOUD_PROVIDER_NAME-prod.yaml 

echo "INFO: serviceAccount input"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'serviceAccountToken' $SERVICE_ACCOUNT --inplace

echo "INFO: masterUrl input"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'masterUrl' $MASTER_URL --inplace

echo "INFO: Cloud Provider Environment Scoping Restrictions for the application"

if ["$ENV_TYPE" == "PROD"] || ["$ENV_TYPE" == "NON_PROD"]; then
    yq w $CLOUD_PROVIDER_NAME-prod.yaml 'usageRestrictions.appEnvRestrictions.[0].envFilter.filterTypes[0]' $ENV_TYPE --inplace
else
    echo "OPTIONS: PROD or NON_PROD"
fi 

echo "INFO: Editting the Skip Validation field in the YAML" 
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'skipValidation' "true" --inplace 

echo "INFO: Use Kubernetes Delegate to False"
yq w $CLOUD_PROVIDER_NAME-prod.yaml 'useKubernetesDelegate' "false" --inplace 
}

fn_summary_creation() {
echo "INFO: Summary of Cloud Provider Creation\n"
cat $CLOUD_PROVIDER_NAME-prod.yaml

}



### MAIN ####
if [ $# -lt 3 ]; then
echo "ERROR: Not enough arguments"
echo "Usage: ./cloud_provider_generator.sh <CLOUD_PROVIDER_NAME> <MASTER_URL> <ENV_TYPE> "
exit 0
fi

if [ -d "Setup" ]; then 
    CLOUD_PROVIDER_NAME=$1
    MASTER_URL=$2
    ENV_TYPE=$3
    echo "INFO: Creating Cloud Provider"
    fn_cloud_provider
else 
  echo "ERROR: No Setup Directory Found"
fi

fn_summary_creation



