# Front End Load Balancer
resource "azurerm_lb" "tier2-LB" {
  name                = "${var.env}-oapp-LoadBalancer"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

# Back End Address Pool
resource "azurerm_lb_backend_address_pool" "tier2" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier2-LB.id}"
  name                = "${var.env}-oapp-BackEndAddressPool"
}

# Load Balancer Rule
resource "azurerm_lb_rule" "tier2-LBRule" {
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier2-LB.id}"
  name                           = "HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PrivateIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier2.id}"
  probe_id                       = "${azurerm_lb_probe.tier2-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier2-LBProbe"]
}

resource "azurerm_lb_probe" "tier2-LBProbe" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier2-LB.id}"
  name                = "HTTP"
  port                = 80
}

resource "azurerm_lb_rule" "tier2-LBRule2" {
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier2-LB.id}"
  name                           = "HTTPSRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PrivateIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier2.id}"
  probe_id                       = "${azurerm_lb_probe.tier2-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier2-LBProbe"]
}

resource "azurerm_lb_probe" "tier2-LBProbe2" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier2-LB.id}"
  name                = "HTTPS"
  port                = 443
}