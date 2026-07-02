variable "aws_region" {
  description = "AWS region used for the cost estimation scenario."
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability zone used for the additional EBS volume."
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type used in the baseline scenario."
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Root volume size in GB for the EC2 instance."
  type        = number
  default     = 8
}

variable "data_volume_size" {
  description = "Additional EBS data volume size in GB."
  type        = number
  default     = 50
}

variable "environment" {
  description = "Environment name used for tagging resources."
  type        = string
  default     = "Dev"
}

variable "project_name" {
  description = "Project name used for tagging resources."
  type        = string
  default     = "cloud-cost-finops"
}