resource "aws_subnet" "private" {
  count                   = "${length(slice(local.az_names, 0, 2))}"
  vpc_id                  = "${aws_vpc.Sagar_VPC.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 3, count.index + length(local.az_names))}"
  availability_zone       = "${local.az_names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}
resource "aws_instance" "nat" {
  ami                    = "${var.nat_amis[var.region]}"
  instance_type          = "t2.micro"
  subnet_id              = "${local.pub_sub_ids[0]}"
  source_dest_check      = false
  vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
  tags = {
    Name = "SagarhomeNat"
  }
}
resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.Sagar_VPC.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags = {
    Name = "SagarHomePrivateRT"
  }
}
