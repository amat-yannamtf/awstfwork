resource "azurerm_resource_group" "amattfrg" {
    location    = var.azregion
    name        = local.resource_group_name
    tags        = {
        Env     = "Development"
    }
}

