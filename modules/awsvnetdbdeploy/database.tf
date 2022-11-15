# Db subnet group
resource "aws_db_subnet_group" "amatdb" {
    name        = format("amat-%s", lower(terraform.workspace))
    subnet_ids  = [aws_subnet.subnets[2].id, aws_subnet.subnets[3].id]
  
}

# db instance

resource "aws_db_instance" "db" {
    count                       = terraform.workspace == "UAT"? 1 : 0
    allocated_storage           = 20
    apply_immediately           = true
    auto_minor_version_upgrade  = false
    backup_retention_period     = 0
    db_subnet_group_name        = aws_db_subnet_group.amatdb.name
    engine                      = "postgres"
    identifier                  = "amatrdsfortf" 
    instance_class              = "db.t3.micro"
    multi_az                    = false
    db_name                     = "deployeddb"
    username                    = "postgres"
    password                    = "postgres" 
    vpc_security_group_ids      = [aws_security_group.dbsg.id]
    skip_final_snapshot         = true
}