# Create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.env}-vnet"
  address_space       = ["${var.supernet}"]
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  dns_servers         = ["8.8.8.8"]
}

# Create subnets
resource "azurerm_subnet" "subnet1" {
  name                      = "${var.env}-web_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "${cidrsubnet(var.supernet,12,0)}"
  network_security_group_id = "${azurerm_network_security_group.tier1_fw.id}"
}

resource "azurerm_subnet" "subnet2" {
  name                      = "${var.env}-oapp_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "${cidrsubnet(var.supernet,12,1)}"
  network_security_group_id = "${azurerm_network_security_group.tier2_fw.id}"
}

resource "azurerm_subnet" "subnet3" {
  name                      = "${var.env}-sql_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "${cidrsubnet(var.supernet,12,2)}"
  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"
}

resource "azurerm_subnet" "subnet4" {
  name                      = "${var.env}-iapp_tier"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "${cidrsubnet(var.supernet,12,3)}"
  network_security_group_id = "${azurerm_network_security_group.tier4_fw.id}"
}

resource "azurerm_subnet" "subnet5" {
  name                      = "${var.env}-management_net"
  resource_group_name       = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  address_prefix            = "172.19.255.0/24"
  network_security_group_id = "${azurerm_network_security_group.tier5_fw.id}"
}
