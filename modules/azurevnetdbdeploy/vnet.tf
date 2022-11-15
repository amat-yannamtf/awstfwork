resource "azurerm_virtual_network" "amatvnet" {
    name                = "amat"
    resource_group_name = local.resource_group_name
    address_space       = [var.vnet_range]
    location            = var.azregion
    tags                = {
        Env             = "Development"
    } 
    # explicit dependency
    depends_on = [
      azurerm_resource_group.amattfrg
    ]
}


resource "azurerm_subnet" "subnets" {
    resource_group_name     = local.resource_group_name
    virtual_network_name    = azurerm_virtual_network.amat.name
    address_prefixes        = [cidrsubnet(var.vnet_range,8,count.index)]
    name                    = var.subnet_names[count.index]
    count                   = length(var.subnet_names)
    service_endpoints       = var.subnet_names[count.index] == "db-1"? ["Microsoft.Sql"]: []

    depends_on = [
      azurerm_virtual_network.amatvnet
    ]

  
}

resource "azurerm_network_security_group" "webnsg" {
    name                            = "webnsg"
    resource_group_name             = local.resource_group_name
    location                        = var.azregion
    security_rule {
        name                       = "openssh"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "openhttp"
        priority                   = 310
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "open8080"
        priority                   = 320
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    depends_on = [
      azurerm_resource_group.amattfrrg
    ]
  
}

# create a public ip

resource "azurerm_public_ip" "webip" {
    name                            = "webip"
    resource_group_name             = local.resource_group_name
    location                        = var.azregion
    sku                             = "Basic"
    allocation_method               = "Dynamic"

    depends_on = [
      azurerm_resource_group.amattfrg
    ]

  
}

# Create a network interface
resource "azurerm_network_interface" "web_nic" {
    name                                = "webnic"
    resource_group_name                 = local.resource_group_name
    location                            = var.azregion

    ip_configuration {
        name                            = "webip"
        subnet_id                       = azurerm_subnet.subnets[0].id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.webip.id
    }

    depends_on = [
        azurerm_subnet.subnets,
        azurerm_public_ip.webip
    ]       
  
}

resource "azurerm_network_interface_security_group_association" "webnicnsg" {
    network_interface_id            = azurerm_network_interface.web_nic.id
    network_security_group_id       = azurerm_network_security_group.webnsg.id
  
}