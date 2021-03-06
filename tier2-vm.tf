# Create virtal machine and define image to install on VM 

resource "azurerm_virtual_machine" "tier2-vm" {
  count = "${var.apptiercount}"
  #name  = "${var.env}oapp-${count.index + 1}"
  name  = "${format("%soapp%03d",var.env,count.index + 1)}"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.tier2-nics.*.id, count.index)}"]
  availability_set_id              = "${azurerm_availability_set.tier2-AvailabilitySet.id}"
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  vm_size                          = "${var.appserversize}"

  storage_image_reference {
    # publisher = "MicrosoftWindowsServer"
    # offer     = "WindowsServer"
    # sku       = "2012-R2-Datacenter"
    # version   = "latest"
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  plan {
    name      = "${var.image_sku}"
    publisher = "${var.image_publisher}"
    product   = "${var.image_offer}"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "${var.env}app${count.index}-osdisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier2-osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "${var.env}app${count.index}-datadisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier2-datadisk${count.index}.vhd"
    disk_size_gb  = "50"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "${var.env}oapp${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"

    #    custom_data = <<EOF
    #<script>
    #  winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
    #</script>
    #<powershell>
    #  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
    #  $admin = [adsi]("WinNT://./administrator, user")
    #  $admin.psbase.invoke("SetPassword", "${var.admin_password}")
    #</powershell>
    #EOF
  }
  os_profile_windows_config {
    enable_automatic_upgrades = "true"
    provision_vm_agent        = "true"
  }


}

#
# Extensions exist for 
# Chef/Octoput/TrendMicro etc 
# but I need available resource to point them at to make them work
#
# resource "azurerm_virtual_machine_extension" "tier2-vmext" {
#  name                 = "hostname"
#  location             = "${azurerm_resource_group.ResourceGrps.location}"
#  resource_group_name  = "${azurerm_resource_group.ResourceGrps.name}"
#  virtual_machine_name = "${element(azurerm_virtual_machine.tier2-vm.*.name, count.index)}"
#  publisher            = "Microsoft.Compute"
#  type                 = "CustomScriptExtension"
#  type_handler_version = "1.8"
#  settings = <<SETTINGS
#    {
#        "commandToExecute": "hostname"
#    }
#SETTINGS
#  tags {
#    environment = "test"
#  }
#}