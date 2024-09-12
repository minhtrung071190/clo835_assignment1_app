#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Data block to retrieve the default VPC id
data "aws_vpc" "default" {
  default = true
}

# Launch EC2 instance
resource "aws_instance" "web_instance" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  iam_instance_profile 	      = "LabInstanceProfile"
  key_name                    = "clo835_assign1"

 
 user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
 EOF
}

# Create ECR repository
resource "aws_ecr_repository" "webapp_repo" {
  name = "webapp"
}

resource "aws_ecr_repository" "mysql_repo" {
  name = "mysql"
}

