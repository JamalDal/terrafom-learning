resource "aws_vpc" "vpc-uk" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags          =  local.common_tag_uk


}

resource "aws_vpc" "vpc-usa" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags          =  local.common_tag_usa


}