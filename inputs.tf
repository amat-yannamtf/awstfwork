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
    default = "AKIAYGCA2KDK5CH5JCWC"
}

variable "secretkey" {
     type = string
     default = "2gsxEQEgvgsgZ4lH47Oaf55EAwzKdkAst+5x3XBy"
}

variable "region" {
  type = string
  default = "us-west-2"
}
