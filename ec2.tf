provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
    description = "ec2 instance type"
    default = "t2.micro"
    type = string
}

variable "key_pair" {
    description = "ec2 instance key pair"
    default = "devops-training"
    type = string
}

variable "security_group_name" {
    description = "ec2 instance security group name"
    default = "devops-practice-sg"
    type = string
}

variable "instance_name" {
    description = "ec2 instance name"
    default = "hcp-cloud-test"
    type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_pair
  security_groups = [var.security_group_name]
  tags = {
      Name = var.instance_name
  }
  user_data_base64 = "IyEvYmluL2Jhc2gKIyBVc2VyIGRhdGEgc2NyaXB0IGZvciBVYnVudHUgdG8gaW5zdGFsbCBBcGFjaGUgYW5kIGRpc3BsYXkgaG9zdG5hbWUKYXB0IHVwZGF0ZSAteQphcHQgaW5zdGFsbCAteSBhcGFjaGUyCnN5c3RlbWN0bCBzdGFydCBhcGFjaGUyCnN5c3RlbWN0bCBlbmFibGUgYXBhY2hlMgplY2hvICI8aDE+SGVsbG8gV29ybGQgZnJvbSAkKGhvc3RuYW1lIC1mKTwvaDE+IiA+IC92YXIvd3d3L2h0bWwvaW5kZXguaHRtbA=="
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "instance_public_ip" {
  value = aws_instance.ec2.public_ip
}
