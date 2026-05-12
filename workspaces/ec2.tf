resource "aws_instance" "terraform" {
  ami = "ami-0220d79f3f480ecf5"
  instance_type = lookup(var.instance_type, terraform.workspace )
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  
  tags = merge(
      local.common_tags,
      {
        Name = "${local.common_name}-workspace"
      }
    )
}

resource "aws_security_group" "allow_all" {
  name        = "${local.common_name}-workspace"
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

  tags = {
    Name = "allow_all"
  }
}