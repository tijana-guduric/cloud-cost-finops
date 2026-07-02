output "demo_instance_type" {
  description = "Instance type used for the demo EC2 server."
  value       = var.instance_type
}

output "demo_root_volume_size" {
  description = "Root volume size in GB."
  value       = var.root_volume_size
}

output "demo_data_volume_size" {
  description = "Additional EBS data volume size in GB."
  value       = var.data_volume_size
}