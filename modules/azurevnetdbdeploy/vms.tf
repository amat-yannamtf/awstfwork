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
    admin_password                      = "Amatglobaluser@123"
    disable_password_authentication     = false
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
      password      = "Amatglobaluser@123"
      host          =  "${azurerm_linux_virtual_machine.web1vm.public_ip_address}"
    }

    provisioner "file" {
      connection {
        type          = "ssh"
        user          = "amatglobaluser"
        password      = "Amatglobaluser@123"
        host          = "${azurerm_linux_virtual_machine.web1vm.public_ip_address}"
      }
      content = <<EOF
         #!/bin/bash
         sudo apt update
         sudo apt install openjdk-11-jdk -y
         sudo apt install apache2 -y
         mkdir ~/apps 
         cd ~/apps
         wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/war/2.377/jenkins.war
         java -jar jenkins.war &
         sleep 60s
        EOF
         destination   = "/tmp/deployjenkins.sh" 
      
    }

    provisioner "remote-exec" {
      connection {
        type          = "ssh"
        user          = "amatglobaluser"
        password      = "Amatuser@123" 
        host          = "${azurerm_linux_virtual_machine.web1vm.public_ip_address}"
      }
        inline = [
          "chmod +x /tmp/deployjenkins.sh",
          "/tmp/deployjenkins.sh",
        ]
    }

    depends_on = [
      azurerm_linux_virtual_machine.web1vm
    ]
  
}