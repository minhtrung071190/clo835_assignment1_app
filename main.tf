provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "default-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-00beae93a2d981137" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  associate_public_ip_address = true
  key_name      = "my-key"  # Reference the newly created key pair

  tags = {
    Name       = "web-server"
    Public_Key = "bsabbah@gmail.com"
  }
}

resource "aws_ecr_repository" "webapp" {
  name = "webapp"
}

resource "aws_ecr_repository" "mysql" {
  name = "mysql"
}

# resource "aws_internet_gateway" "example" {
#   vpc_id = aws_vpc.default.id

#   tags = {
#     Name = "example-igw"
#   }
# }

# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.default.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   tags = {
#     Name = "example-route-table"
#   }
# }

output "web_instance_public_dns" {
  value = aws_instance.web.public_dns
}
