resource "azurerm_mssql_server" "amatdbserver" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "amattfsqlserver"
    resource_group_name             = local.resource_group_name
    location                        = var.azregion
    version                         = "12.0" 
    administrator_login             = "amatglobaluser"
    administrator_login_password    = "Amatuser@123"

    depends_on = [
      azurerm_resource_group.amattfrg
    ]
}

resource "azurerm_mssql_database" "amatdb" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "amatsqldbdb"
    resource_group_name             = local.resource_group_name
    location                        = var.azregion
    server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    edition                         = "Basic" 

    depends_on = [
      azurerm_mssql_server.amatdbserver
    ]
  
}


# Adding vnet connection
resource "azurerm_sql_virtual_network_rule" "allowamatvent" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "amatvnetdb"
    resource_group_name             = local.resource_group_name
    server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    # needs to be fixed
    subnet_id                       = azurerm_subnet.subnets[2].id

    depends_on = [
      azurerm_mssql_database.amatdb,
      azurerm_subnet.subnets
    ] 
}

# Allow all the ip address from vnet range to access database
resource "azurerm_sql_firewall_rule" "allow_all_vnet" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "allowvnet"
    resource_group_name             = local.resource_group_name
    server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    start_ip_address                = cidrhost(var.vnet_range, 0)
    end_ip_address                  = cidrhost(var.vnet_range, 65535)


    depends_on = [
      azurerm_mssql_database.amatdb,
      azurerm_subnet.subnets
    ]
  
}