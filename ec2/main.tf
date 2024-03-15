terraform {
  backend "s3" {
    # Имя корзины, которое определили в самом начале
    bucket = "terraform-state-bucket-maksat"
    # Путь к файлу состояния Terraform
    key = "global/s3/terraform-ec2.tfstate"
    region = "us-east-1"
    
    # Имя таблицы в DynamoDB, которое определили в самом начале
    dynamodb_table = "terraform-state-locks"
    encrypt = true 
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "from-terraform-ubuntu" {
  count = 1
  ami = "ami-0b98a32b1c5e0d105"
  instance_type = var.ec2-type
  subnet_id = "subnet-048c2c7139defb91e"
  tags = {
    Name = "from-k8s"
    role = "k8s"
  }
}

#resource "aws_instance" "from-terraform-al" {
 # count = 1
#  ami = "ami-025a6a5beb74db87b"
#  instance_type = var.ec2-type
#  subnet_id = "subnet-0c621a57263c94961"
#  tags = {
#    Name = "from-terraform"
#    role = "nginx"
#  }
# }
