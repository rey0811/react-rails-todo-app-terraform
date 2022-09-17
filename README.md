# Overview
This terraform script generates all AWS environments except for part of Route 53 and ACM resources.

## 0. Prerequisite

```
terraform --version
Terraform v1.2.9
on darwin_amd64
+ provider registry.terraform.io/hashicorp/aws v4.30.0
+ provider registry.terraform.io/hashicorp/null v3.1.1
```
## 1. How to create new environment
---
### A. Manual preparation
- Create `terraform.tfvars` from `terraform.tfvars.example` and set value for each key
- Get a domain name in [onamae.com](https://www.onamae.com/)
- Create a record in Route53 with domain name specified in `my_domain`
- Register name servers in [onamae.com](https://www.onamae.com/)
- Create a certification in ACM
- Create a key pair for EC2 with name specified in `ec2_keypair`

### B. Terraform command

- Run `terraform apply` at the top directory
## 2. How to connect to RDS via SSM
- Install Session Manager Plugin in reference to [Install the Session Manager plugin for the AWS CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- Add the below setting in `~/.ssh/config`

```
host private_rds
    ProxyCommand sh -c "aws ssm start-session --target ${EC2_INSTANCE_ID} --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    User ${EC2_USER_NAME}
    LocalForward 3306 ${RDS_ENDPOINT}:3306
    IdentityFile ${PATH_TO_KEYPAIR}
```

- Run `ssh private_rds` and confirm that you can login to ec2
  - If you encounter `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`, please run `ssh-keygen -R private_rds` and run `ssh private_rds` again.

- Install [MySQL WorkBench](https://www.mysql.com/products/workbench/)
- Set the below items and confirm your connection to RDS
  - `Hostname`: localhost
  - `Port`: 3306
  - `Username`: RDS_USERNAME
  - `Password`: RDS_PASSWORD
## 3. How to login to ecs container by ECS Exec

Replace ${task_name} with actual task name and run the below command.

```
aws ecs execute-command \
    --cluster todo-prd-ecs-cluster \
    --task ${task_name} \
    --container todo-api-container \
    --interactive \
    --command "/bin/sh"
```

## 4. How to destroy the environment created by `terraform apply`
Run `terraform destroy` at the top directory
