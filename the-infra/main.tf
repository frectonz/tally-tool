terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }

  backend "s3" {
    bucket         = "tally-tool-terraform"
    key            = "network/terraform.tfstate"
    dynamodb_table = "tally-tool-terraform"
    region         = "eu-west-3"
  }
}

provider "aws" {
  region = "eu-west-3"
}

data "aws_elastic_beanstalk_solution_stack" "ruby" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) Ruby 3.0$"
}

resource "aws_elastic_beanstalk_application" "tally_tool_app" {
  name = "TallyTool"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "tally_tool_app_env" {
  name                = "TallyToolEnv"
  application         = aws_elastic_beanstalk_application.tally_tool_app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.ruby.name
  tier                = "WebServer"
  cname_prefix        = "tally-tool"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_profile.name
  }
}

resource "aws_iam_instance_profile" "beanstalk_profile" {
  name = "BeanstalkInstanceProfile"
  role = aws_iam_role.beanstalk_profile_role.name
}

resource "aws_iam_role" "beanstalk_profile_role" {
  name = "BeanstalkServiceProfileRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_profile_policy" {
  role       = aws_iam_role.beanstalk_profile_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role" "beanstalk_service" {
  name = "BeanstalkServiceRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_policy" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
