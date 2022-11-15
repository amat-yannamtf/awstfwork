resource "azurerm_mssql_server" "amatdbserver" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "amattfsqlserver"
    resource_group_name             = local.resource_group_name
    location                        = var.region
    version                         = "12.0" 
    administrator_login             = "amatglobaluser"
    administrator_login_password    = "Amatuser@123"

    depends_on = [
      azurerm_resource_group.amattfrg
    ]
}

resource "azurerm_mssql_database" "amatdb" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "amattfsqldbdb"
    //resource_group_name             = local.resource_group_name
    //location                        = var.region
    //server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    //edition                         = "Basic" 
    server_id                       = azurerm_mssql_server.amatdbserver[count.index].id

    depends_on = [
      azurerm_mssql_server.amatdbserver
    ]
  
}


# Adding vnet connection
resource "azurerm_mssql_virtual_network_rule" "allowamatvnet" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "allowsqlvnetrule"
    //resource_group_name             = local.resource_group_name
    //server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    server_id                       = azurerm_mssql_server.amatdbserver[count.index].id
    # needs to be fixed
    subnet_id                       = azurerm_subnet.subnets[2].id
    ignore_missing_vnet_service_endpoint = true

    depends_on = [
      azurerm_mssql_database.amatdb,
      azurerm_subnet.subnets
    ] 
}

# Allow all the ip address from vnet range to access database
resource "azurerm_mssql_firewall_rule" "allow_all_vnet" {
    count                           = var.create_db == "yes"? 1 : 0 
    name                            = "allowsqlfwrule"
    //resource_group_name             = local.resource_group_name
    //server_name                     = azurerm_mssql_server.amatdbserver[count.index].name
    server_id                       = azurerm_mssql_server.amatdbserver[count.index].id
    start_ip_address                = cidrhost(var.vnet_range, 0)
    end_ip_address                  = cidrhost(var.vnet_range, 65535)


    depends_on = [
      azurerm_mssql_database.amatdb,
      azurerm_subnet.subnets
    ]
  
}

/*resource "azurerm_subnet_service_endpoint_storage_policy" "example" {
  name                = "example-policy"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  definition {
    name        = "name1"
    description = "definition1"
    service_resources = [
      azurerm_resource_group.example.id,
      azurerm_storage_account.example.id
    ]
  }
}*/