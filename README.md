# Teleport Auto Discovery: Terraform Infrastructure Setup

This repository contains Terraform configurations for setting up AWS resources and installing Teleport. 

## Prerequisites

Before running the Terraform scripts, ensure that you have the following:

- **Terraform**: Download Terraform and install it.
- **Teleport**: Install Teleport which will also install tctl and tsh 
- **AWS CLI**: Install AWS CLI to interact with AWS services from the command line.
- **AWS Account**: Ensure you have access to an AWS account.
- **AWS Credentials**: Ensure your AWS credentials are properly configured.

## Steps to Deploy Infrastructure

### 1. Clone the Repository

Clone the repository to your local machine:

### 2. Terraform Apply

There are helper scripts in `scripts/local/tf-*.sh`
 
Run the follow command to apply

```
cd tf && ../scripts/local/tf-apply.sh
```
The script also uses tctl for Teleport credentials. 
This should create the plan in `REPO_ROOT/tf/plans/`. 

### Clean Up Resources

Run the following command to destroy 

```
cd tf/ && ../scripts/local/tf-destroy.sh
```

This will remove all resources in the cloud, and plans locally. 
