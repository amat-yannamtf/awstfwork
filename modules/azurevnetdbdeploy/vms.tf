resource "azurerm_linux_virtual_machine" "web1vm" {
    name                                = "amatweb1vm"
    resource_group_name                 = local.resource_group_name
    location                            = var.region
    network_interface_ids               = [azurerm_network_interface.web_nic.id] 
    size                                = "Standard_B1s"
    os_disk {
        caching                         = "ReadWrite"
        storage_account_type            = "Standard_LRS"
    }
    admin_username                      = "amatglobaluser"
    disable_password_authentication     = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = file("~/.ssh/id_rsa.pub")
    }
    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    depends_on = [
      azurerm_network_interface.web_nic,
      azurerm_network_security_group.webnsg
    ]
  
}

resource "null_resource" "deployapp" {

    triggers = {
        build_id = var.build_id
    }

    connection {
      type          = "ssh"
      user          = "amatglobaluser"
      private_key   = "${file("~/.ssh/id_rsa")}"
      host          = azurerm_linux_virtual_machine.web1vm.public_ip_address
    }

    provisioner "file" {
      source        = "deployspc.sh"
      destination   = "/tmp/deployspc.sh" 
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/deployspc.sh",
          "/tmp/deployspc.sh",
        ]
    }

    depends_on = [
      azurerm_linux_virtual_machine.web1vm
    ]
  
}