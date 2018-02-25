resource "azurerm_network_security_group" "tier4_fw" {
  name                = "${var.env}-iapp_fw"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  security_rule {
    name                       = "allow-tcp-sql"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "${cidrsubnet(var.supernet,12,3)}"
    destination_address_prefix = "${cidrsubnet(var.supernet,12,2)}"
  }

  security_rule {
    name                       = "allow-RDP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "172.19.255.0/24"
    destination_address_prefix = "${cidrsubnet(var.supernet,12,3)}"
  }
}
