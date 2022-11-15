module "awsvnetdbdeploy" {
    source          = "./modules/awsvnetdbdeploy"
    vpc_cidr        = var.vpc_cidr
    instance_type   = var.instance_type
    subnet_cidrs    = var.subnet_cidrs
    subnet_azs      = var.subnet_azs
    subnet_names    = var.subnet_names
    
}



output "awswebip" {
    value = module.awsvnetdbdeploy.web1_publicip
  
}

