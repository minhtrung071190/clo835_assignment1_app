provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "instance" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = "t2.micro"
  iam_instance_profile = "LabInstanceProfile"
  # key_name      = "MyProject-Keypair"
  key_name = aws_key_pair.nila_key.id

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
  EOF
}

resource "aws_ecr_repository" "web-ecr" {
  name = "my_app_1"
}

resource "aws_ecr_repository" "mysql-ecr" {
  name = "my_db_1"
}

#Resource to create a SSH private key
resource "aws_key_pair" "nila_key" {
  key_name   = "no_name"
  public_key = ""
}
