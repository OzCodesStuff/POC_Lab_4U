# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
 
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "9368ed2a-1a0a-41b4-bf06-40a754473be9"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a key vault
resource "azurerm_key_vault" "kv" {
  name                        = "myTFKeyVault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = "<your_tenant_id>"
  sku_name                    = "standard"
  purge_protection_enabled    = false
}

# Create a virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "myTFVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ni.id] # Add the missing attribute

  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = ""
    admin_password = ""
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Remove the duplicate definition of the "network_interface_ids" attribute
  # network_interface_ids = [azurerm_network_interface.ni.id]
}


# Create a Log Analytics workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "myTFLogAnalyticsWorkspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
