resource "aws_vpc" "Sagar_VPC" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name        = "SagarhomeVpc"
    Environment = "${terraform.workspace}"
  }
}
