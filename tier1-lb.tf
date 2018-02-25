# VIP address
resource "azurerm_public_ip" "lbIP" {
  name                         = "${var.env}-weblbip"
  location                     = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGrps.name}"
  public_ip_address_allocation = "static"
}

# Front End Load Balancer
resource "azurerm_lb" "tier1-LB" {
  name                = "${var.env}-web-LoadBalancer"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  frontend_ip_configuration {
    name                 = "${var.env}-PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lbIP.id}"
  }
}

# Back End Address Pool
resource "azurerm_lb_backend_address_pool" "tier1" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier1-LB.id}"
  name                = "${var.env}-web-BackEndAddressPool"
}

# Load Balancer Rule
resource "azurerm_lb_rule" "tier1-LBRule" {
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier1-LB.id}"
  name                           = "${var.env}-HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier1.id}"
  probe_id                       = "${azurerm_lb_probe.tier1-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier1-LBProbe"]
}

resource "azurerm_lb_rule" "tier1-LBRule2" {
  resource_group_name            = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id                = "${azurerm_lb.tier1-LB.id}"
  name                           = "${var.env}-HTTPSRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.tier1.id}"
  probe_id                       = "${azurerm_lb_probe.tier1-LBProbe.id}"
  depends_on                     = ["azurerm_lb_probe.tier1-LBProbe2"]
}

resource "azurerm_lb_probe" "tier1-LBProbe" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier1-LB.id}"
  name                = "${var.env}-HTTPProbe"
  port                = 80
}

resource "azurerm_lb_probe" "tier1-LBProbe2" {
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"
  loadbalancer_id     = "${azurerm_lb.tier1-LB.id}"
  name                = "${var.env}-HTTPSProbe"
  port                = 443
}