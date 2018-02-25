resource "azurerm_network_interface" "tier3-nics" {
  count               = "${var.dbtiercount}"
  name                = "${var.env}.vmnic-sql-${count.index + 1}"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  network_security_group_id = "${azurerm_network_security_group.tier3_fw.id}"

  ip_configuration {
    name                                    = "${var.env}-ipconfig-db${count.index +1}"
    subnet_id                               = "${azurerm_subnet.subnet3.id}"
    private_ip_address_allocation           = "Static"
    private_ip_address                      = "${cidrhost(azurerm_subnet.subnet3.address_prefix,count.index+5)}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.tier3.id}"]
  }
}
