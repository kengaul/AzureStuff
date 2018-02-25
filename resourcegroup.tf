# Configure the Azure ARM provider
provider "azurerm" {
}

# Create a resource group
resource "azurerm_resource_group" "ResourceGrps" {
  name     = "${var.env}-rg"
  location = "${var.location}"
}
