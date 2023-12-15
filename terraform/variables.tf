# core

variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}


# networking

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2b", "us-west-2c"]
}


# load balancer

variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/ping"
}


# ecs

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "demo"
}

variable "docker_image_url_fastapi" {
  description = "Docker image to run in the ECS cluster"
  default     = "<AWS_ACCOUNT_ID>.dkr.ecr.us-west-2.amazonaws.com/fastapi-app:latest"
}

variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Amount of CPU for Fargate task. E.g., '256' (.25 vCPU)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Amount of memory for Fargate task. E.g., '512' (0.5GB)"
  default     = "512"
}

# logs

variable "log_retention_in_days" {
  default = 30
}


# ECS service auto scaling

variable "autoscale_min" {
  description = "Minimum autoscale (number of tasks)"
  default     = "1"
}

variable "autoscale_max" {
  description = "Maximum autoscale (number of tasks)"
  default     = "10"
}

variable "autoscale_desired" {
  description = "Desired number of tasks to run initially"
  default     = "4"
}
