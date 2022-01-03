resource "aws_spot_instance_request" "minecraft" {
  ami = data.aws_ami.ubuntu.id

  instance_type = var.node_type

  root_block_device {
    volume_size = 50
  }

  instance_interruption_behavior = "stop"

  wait_for_fulfillment = true

  user_data = templatefile("${path.module}/../cloud-init.tpl", {
    ssh_key = var.public_key
  })

  vpc_security_group_ids = [
    aws_security_group.allow.id
  ]

  tags = {
    Name = "Minecraft"
  }
}
