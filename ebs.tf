resource "aws_ebs_volume" "uk" {
  availability_zone = "us-east-1a"
  size              = 10
  tags          =  local.common_tag_uk

}


resource "aws_ebs_volume" "usa" {
  availability_zone = "us-east-1a"
  size              = 10
  tags          =  local.common_tag_usa

}