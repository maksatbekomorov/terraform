terraform {
  backend "s3" {
    # Имя корзины, которое определили в самом начале
    bucket = "terraform-state-bucket-maksat"
    # Путь к файлу состояния Terraform
    key    = "global/s3/terraform-mariadb.tfstate"
    region = "us-east-1"

    # Имя таблицы в DynamoDB, которое определили в самом начале
    dynamodb_table = "terraform_state_locks"
    encrypt        = true
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

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "security_groups-flatris" {
  source = "../modules/security-group"
  app-port = 3000
}

module "flatris" {
  source = "../modules/flatris"
  ec2-type = "t2.micro"
  ssh-key-name = aws_key_pair.ssh_key.key_name
  security-group-id = [ module.security_groups-flatris.allow_to_flatris_id ]
}


output "flatris-from-ubuntu-ip" {
  value = module.flatris.flatris-ubuntu-ip
}

