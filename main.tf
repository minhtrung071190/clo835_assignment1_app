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

  tags = {
    Name = "Instance_2"
  }

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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt+EjU2a36DsUvlnfxi7vZJo/WOQVfrE3qT4tl1rw6sPkaK+AFXXtDS5RDuDq72xCMK8aHd5HoQfivBJgp34WlcMqYKM0wf71ommoKiqqsdzE4QsyyCwQyuVMt6fK6DtUViqXynlpmj0zG7txDcz8pnHoaeDXb1LaAy1GFWbmxpvQPwH38e7YZMyTqzm6nTc0aJTcXK/r31kW3IZkWt7fRaHxKyqHBLk24YckuNnFOl6tiK8SL23fEU74VSNQ49C3uzjlL1skTw6iy3QBnyPb3FemUwwHzEMeUlFmUheEmXtQkoz9DwSbHhV8YBCQFJ6JHqu1/SVrgUpQVeB3xDd/N ec2-user@ip-172-31-69-108.ec2.internal"
}
#Testing 123
