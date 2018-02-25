resource "azurerm_network_interface" "tier1-nics" {
  count               = "${var.webtiercount}"
  name                = "${var.env}-vmnic-web-${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  network_security_group_id = "${azurerm_network_security_group.tier1_fw.id}"

  ip_configuration {
    name                                    = "${var.env}-ipconfig-web${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "${cidrhost(azurerm_subnet.subnet1.address_prefix,count.index+5)}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier1.id}"]
  }
}
