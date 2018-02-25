variable "supernet" {
  default = "172.18.0.0/15"
}

variable "admin_username" { 
  default = "watcher" 
  }

variable "admin_password" {}

variable "webtiercount" {
  default = 2
}

variable "apptiercount" {
  default = 2
}

variable "iapptiercount" {
  default = 3
}

variable "dbtiercount" {
  default = 2
}

variable "env" {}

variable "project" {
  default = "FNZ"
}

variable "usage" {
  default = "dev"
}

variable "location" {
  default = "uksouth"
}

variable "webserversize" {
  default = "Standard_D2_v2"
} 

variable "appserversize" {
  default = "Standard_D2_v2"
} 

variable "iappserversize" {
  default = "Standard_D4_v2"
} 

variable "sqlserversize" {
  default = "Standard_D8_v2"
} 

variable "image_publisher" {
  default = "center-for-internet-security-inc"
}

variable "image_offer" {
  default = "cis-windows-server-2016-v1-0-0-l2"
}

variable "image_sku" {
  default = "cis-ws2016-l2"
}

variable "image_version" {
  default = "latest"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}
