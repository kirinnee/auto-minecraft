output "server_ip" {
  value = aws_spot_instance_request.minecraft.public_ip
}

output "instance_id" {
  value = aws_spot_instance_request.minecraft.spot_instance_id
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}
