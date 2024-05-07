output "resource_group_id" {
    description = "The ID of the created resource group"
    value       = azurerm_resource_group.rg.id
}

output "storage_account_id" {
    description = "The ID of the created storage account"
    value       = azurerm_storage_account.sa.id
}

output "virtual_network_id" {
    description = "The ID of the created virtual network"
    value       = azurerm_virtual_network.vnet.id
}

output "key_vault_id" {
    description = "The ID of the created key vault"
    value       = azurerm_key_vault.kv.id
}

output "virtual_machine_id" {
    description = "The ID of the created virtual machine"
    value       = azurerm_virtual_machine.vm.id
}

output "log_analytics_workspace_id" {
    description = "The ID of the created Log Analytics workspace"
    value       = azurerm_log_analytics_workspace.law.id
}
