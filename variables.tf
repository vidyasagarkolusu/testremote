variable "vpc_cidr" {
  description = "Choose cidr for vpc"
  type        = string
  default     = "10.20.0.0/16"
}

variable "region" {
  description = "Choose region for your stack"
  type        = string
  default     = "us-east-1"
}
variable nat_amis {
  type = map
  default = {
    us-east-1 = "ami-0dc2d3e4c0f9ebd18"  #Amazon Linux 2 AMI
    us-east-2 = "ami-0233c2d874b811deb" #Amazon Linux 2 AMI
  }
}