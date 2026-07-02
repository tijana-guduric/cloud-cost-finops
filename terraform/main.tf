locals {
  common_tags = {
    Service     = var.project_name
    Environment = var.environment
  }
}

resource "aws_instance" "demo_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-demo-server"
  })

  volume_tags = merge(local.common_tags, {
    Name = "${var.project_name}-root-volume"
  })
}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = var.availability_zone
  size              = var.data_volume_size
  type              = "gp3"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-data-volume"
  })
}