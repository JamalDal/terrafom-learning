variable "elb_name" {
  type = string
  default = "elbjamal"

}

variable "availability_zones_name" {
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"] # "us-east-2b", "us-east-2c"
}

variable "timeout" {
  type = number
  default = 200
}


# variable "ami" {
#   type = "t2.micro"
#   ami  = "ami-026b57f3c383c2eec"
# }

variable "instance-type" {
  type = map
  default = {
    "dev" = "t2.micro",
    "test" = "t2.micro",
    "prod" = "t2.micro"
  }
}

variable "ami-id" {
    type = list
    default = ["ami-026b57f3c383c2eec", "ami-08c40ec9ead489470", "ami-06640050dc3f556bb"]

}


variable "tags" {
  type = list
  default = ["dev-dp", "test-dp", "prod-dp"]
}

variable "inoput" {}



# variable "mapvar" {
#   type = map
#   dafuult= [
#     us-east-1a = "t2.micro"
#     us-east-1b = "t2.micro"
#     us-east-1c = "t2.micro"
#  ]
# }