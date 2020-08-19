variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "ap-southeast-2"
}

variable "cluster_name" {
  description = "Cluster name"
  default     = "my_app_cluster"
}

variable "task_count" {
  description = "Task Count"
  default     = 2
}

variable "image_url" {
  description = "image_url"
  default     = "034818602755.dkr.ecr.ap-southeast-2.amazonaws.com/my-app:latest"
}