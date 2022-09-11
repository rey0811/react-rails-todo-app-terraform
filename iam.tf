data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_policy" "custom_ecs_task_policy" {
  description = "Custom policy for ECS Task Role. Allow to use ECS Exec"
  name        = "CustomECSTaskPolicy"
  path        = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel",
        "ecs:ExecuteCommand"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "AllowsECSExec"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "custom_ecs_task_execution_policy" {

  description = "Custom policy for ECS Task Execution Role"
  name        = "CustomECSTaskExecutionPolicy"
  path        = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "AllowsPullingImagesFromECRAndPublishCloudWatchLogs"
    },
    {
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "AllowsAccessToSSMAndSecretsManager"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "custom_githubactions_policy" {
  description = "Custom policy in order for GitHub Actions to access to S3 and CloudFront."
  name        = "CustomGitHubActionsPolicy"
  path        = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "cloudfront:ListDistributions",
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "VisualEditor0"
    },
    {
      "Action": [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::todo-prd-front",
        "arn:aws:s3:::todo-prd-front/*"
      ],
      "Sid": "VisualEditor1"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_role" "todo_ecs_task_execution_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows ECS tasks to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::${local.account_id}:policy/CustomECSTaskExecutionPolicy"]
  max_session_duration = "3600"
  name                 = "todo-ecs-task-execution-role"
  path                 = "/"
}

resource "aws_iam_role" "todo_ecs_task_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows ECS tasks to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::${local.account_id}:policy/CustomECSTaskPolicy"]
  max_session_duration = "3600"
  name                 = "todo-ecs-task-role"
  path                 = "/"
}

resource "aws_iam_role" "todo_ec2_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  max_session_duration = "3600"
  name                 = "todo-ec2-role"
  path                 = "/"
}

resource "aws_iam_role" "todo_github_cicd_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::${local.account_id}:policy/CustomGitHubActionsPolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser", "arn:aws:iam::aws:policy/AmazonECS_FullAccess"]
  max_session_duration = "3600"
  name                 = "todo-github-cicd-role"
  path                 = "/"
}
