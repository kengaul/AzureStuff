resource "azurerm_storage_account" "storage" {
  name                = "${var.env}storage"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  location     = "${azurerm_resource_group.ResourceGrps.location}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_replication_type}"


  tags {
    environment = "${var.usage}"
    project = "${var.project}"
  }
}

resource "azurerm_storage_container" "blob1" {
  name                  = "${var.env}-blobstore"
  resource_group_name   = "${azurerm_resource_group.ResourceGrps.name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}
