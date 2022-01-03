resource "aws_security_group" "allow" {
  name        = "Minecraft Security Group ${var.project}"
  description = "Allow all Minecraft and SSH"

  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Allow Minecraft Traffic"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
