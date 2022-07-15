terraform {
  backend "s3" {
    #encrypt            = true
    bucket              = "infrabackstate"
    region              = "us-west-2"
    key                 = "Dev/VPC/terraform.tfstate"
    encrypt             = true
  }
}