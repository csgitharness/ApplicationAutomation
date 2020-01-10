# Introduction

The purpose of this script is to automate the creation of an Application and Cloud Provider, based off a reference Setup in Harness

## Pre - Requisites

1. The user must have a sample application and cloud provider configured in Harness

2. The user must have Config As Code Setup with a bidirectional sync 

3. The user must have a machine that has YQ installed on it

### Install YQ

On MacOS:

```
brew install yq
```

On Ubuntu and other Linux distros supporting snap packages:

```
snap install yq
```

On Ubuntu 16.04 or higher from Debian package:

```
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y
```

## Cloud Provider
For the Cloud Provider, we are changing the


## Application

The application that is generated from the script is based of a "golden application". In this case, I'm using the Application called "referenceRegulated".

As a user, you can change the target application by manipulating the automation.sh script. The user would have to change this variable:

```
REFERENCE_APPLICATION="referenceRegulated"
```

## Quick Start

To run the script, it has to be sitting in the same level as the Setup Folder for Harness. It will navigate through the folder structure and copy and manipulate the existing files using yq

### master.sh

To run both Cloud Provider Creation and Application Creation run the master.sh script


chmod u+x master.sh to make the script runnable


```
./master.sh <CLOUD_PROVIDER_NAME> <MASTER_URL> <APP_NAME> <ENV_TYPE> <INPUT_SERVICE> <PROD_NAMESPACE> <TEST_NAMESPACE>
```

### cloud_provider_generator.sh

This script will generate the cloud provider yaml based off a template cloud provider



```
./cloud_provider_generator.sh <CLOUD_PROVIDER_NAME> <MASTER_URL> <ENV_TYPE> 
```

user will need to commit the code afterwards to sync back to Harness 

### automation.sh

This script will create the YAML necessary for a new application. This includes the service, workflow, pipelines, and environments.

```
./automation.sh <Application_Name> <Service_Name> <PROD_Namespace> <TEST_Namespace>
```