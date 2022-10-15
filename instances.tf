#conditions operators 
#count = var.inoput > "2" ? If True do-this : otherwise; little tricky in case of not equal to > if value passed then pick this otherwise pick false value

resource "aws_instance" "dev-instance" {
  ami           = var.ami-id[0]
  #instance_type = var.instance_type[count.index]
  instance_type = var.instance-type["dev"]
  #count = var.inoput == "dev" ? 5 : 2
  count = var.inoput == "dev" ? 1 : 0
  #count = var.inoput != "" ? var.inoput : 0
  
  tags = {
    #Name = var.tags[0]
    Name = "dev.${count.index}"
    #Name = var.tags[count.index]
    
  }
}


resource "aws_instance" "test-instance" {
  ami           = var.ami-id[1]
  #instance_type = var.instance_type[count.index]
  instance_type = var.instance-type["test"]
  count = var.inoput == "test" ? 2 : 0

  tags = {
    #Name = var.tags[0]
    Name = "test.${count.index}"
    #Name = var.tags[count.index]
    
  }
}


resource "aws_instance" "prod-instance" {
  ami           = var.ami-id[2]
  #instance_type = var.instance_type[count.index]
  instance_type = var.instance-type["prod"]
  count = var.inoput == "prod" ? 3 : 0

  tags = {
    #Name = var.tags[0]
    Name = "prod.${count.index}"
    #Name = var.tags[count.index]
    
  }
}


