resource "aws_instance" "terraform" {
  ami = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  
  tags =  merge(local.common_tags, {
      Name = "${local.common_name}-tfvars-multi-env"
  })
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound and outbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.common_name}-tfvars-multi-env"
  })
}