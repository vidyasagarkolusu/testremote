locals {
  az_names    = "${data.aws_availability_zones.azs.names}"
  pub_sub_ids = "${aws_subnet.public.*.id}"
}

resource "aws_subnet" "public" {
  count                   = "${length(local.az_names)}"
  vpc_id                  = "${aws_vpc.Sagar_VPC.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 3, count.index)}"
  availability_zone       = "${local.az_names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.Sagar_VPC.id}"

  tags = {
    Name = "SagarHomeIgw"
  }
}

resource "aws_route_table" "prt" {
  vpc_id = "${aws_vpc.Sagar_VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "SagarHomePRT"
  }
}

resource "aws_route_table_association" "pub_sub_asociation" {
  count          = "${length(local.az_names)}"
  subnet_id      = "${local.pub_sub_ids[count.index]}"
  route_table_id = "${aws_route_table.prt.id}"
}

resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Allow traffic for private subnets"
  vpc_id      = "${aws_vpc.Sagar_VPC.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}