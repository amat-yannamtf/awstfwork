variable "vpc_cidr" {
    default = "192.168.0.0/16"
    description = "This is the VPC cidr"
    type = string
}

variable "instance_type" {
    default = "t2.micro"
}


variable "subnet_cidrs" {
    default = ["192.168.0.0/24","192.168.1.0/24","192.168.2.0/24","192.168.3.0/24"]
    description = "These are subnet cidr ranges"
}

variable "subnet_azs" {
    default = ["us-west-2a", "us-west-2b", "us-west-2a", "us-west-2b"]
    description = "Availability Zones for the subnets"
}

variable "subnet_names" {
    default = ["Web-1", "Web-2", "DB-1", "DB-2"]
    description = "Names of subnets"
  
}


variable "build_id" {
    default = 1
  
}

variable "create_db" {
    default = "yes"

}

variable "accesskey" {
    type = string 
}

variable "secretkey" {
     type = string
}

variable "awsregion" {
  type = string
}

variable "azregion" {
  type = string
}

variable "subscriptionid" {
    type = string
    default = "c48564fc-efbd-4ccb-af21-b591537f3f1a"
}

variable "tenantid" {
  type = string
  default = "7a0bf23b-a8a4-493e-92b6-229c305481fe"
}

variable "clientid" {
    type = string
    default = "4934fb85-c5c4-4c2a-aceb-2b566bacd294"
}

variable "clientsecret" {
    type = string
    default = "lmE8Q~5YjLVzw5JZNh1SplywzfA~dh~AAmexdbYx"
}
