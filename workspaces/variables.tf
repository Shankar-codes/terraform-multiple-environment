
variable "project"{
    default = "ellamma-roboshop"
}

variable "environment" {
    type = map
    default = {
        dev = "dev"
        prod = "prod"
    }
}


variable "instance_type" {
    type = map
    default = {
        dev = "t3.micro"
        prod = "t3.small"
    }
}
