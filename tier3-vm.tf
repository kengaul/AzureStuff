# Create virtal machine and define image to install on VM 

resource "azurerm_virtual_machine" "tier3-vm" {
  count = "${var.dbtiercount}"
  name  = "${format("%ssql%03d",var.env,count.index + 1)}"

  location = "${azurerm_resource_group.ResourceGrps.location}"

  resource_group_name              = "${azurerm_resource_group.ResourceGrps.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.tier3-nics.*.id, count.index)}"]
  availability_set_id              = "${azurerm_availability_set.tier3-AvailabilitySet.id}"
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  vm_size                          = "${var.sqlserversize}"

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2016SP1-WS2016"
    sku       = "Enterprise"
    version   = "latest"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "${var.env}sql${count.index}-osdisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier3-osdisk${count.index}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "${var.env}sql${count.index}-logdisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier3-datadisk${count.index}.vhd"
    disk_size_gb  = "100"
    create_option = "Empty"
    lun           = 0
  }
  storage_data_disk {
    name          = "${var.env}sql${count.index}-datadisk"
    vhd_uri       = "${azurerm_storage_account.storage.primary_blob_endpoint}${azurerm_storage_container.blob1.name}/tier3-datadisk${count.index}.vhd"
    disk_size_gb  = "250"
    create_option = "Empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "${var.env}sql${count.index}"
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
    enable_automatic_upgrades = "false"
    provision_vm_agent        = "true"
  }
}