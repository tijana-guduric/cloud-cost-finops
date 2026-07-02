locals {
  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "finops-cost-estimation-demo"
    owner       = "student"
    team        = "cloud"
    cost_center = "education"
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
}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = var.availability_zone
  size              = var.data_volume_size
  type              = "gp3"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-data-volume"
  })
}