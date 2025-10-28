# =============================================================================
# VM Resource Outputs
# =============================================================================

output "vm_id" {
  value       = azurerm_linux_virtual_machine.this.id
  description = "The ID of the Linux Virtual Machine"
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.this.name
  description = "The name of the Linux Virtual Machine"
}

output "vm_size" {
  value       = azurerm_linux_virtual_machine.this.size
  description = "The size of the Linux Virtual Machine"
}

output "computer_name" {
  value       = azurerm_linux_virtual_machine.this.computer_name
  description = "The computer name of the Linux Virtual Machine"
}

# =============================================================================
# Network Interface Outputs
# =============================================================================

output "network_interface_id" {
  value       = azurerm_network_interface.this.id
  description = "The ID of the network interface"
}

output "private_ip_address" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "The private IP address of the VM"
}

output "private_ip_addresses" {
  value       = azurerm_network_interface.this.private_ip_addresses
  description = "All private IP addresses of the network interface"
}

# =============================================================================
# Location and Resource Group Outputs
# =============================================================================

output "location" {
  value       = azurerm_linux_virtual_machine.this.location
  description = "The Azure region where the VM is deployed"
}

output "resource_group_name" {
  value       = azurerm_linux_virtual_machine.this.resource_group_name
  description = "The resource group name"
}

# =============================================================================
# Identity Outputs
# =============================================================================

output "identity_principal_id" {
  value       = try(azurerm_linux_virtual_machine.this.identity[0].principal_id, null)
  description = "The Principal ID of the managed identity"
}

output "identity_tenant_id" {
  value       = try(azurerm_linux_virtual_machine.this.identity[0].tenant_id, null)
  description = "The Tenant ID of the managed identity"
}

# =============================================================================
# SSH Access Outputs (Sensitive)
# =============================================================================

output "admin_username" {
  value       = var.admin_username
  description = "The admin username for the VM"
  sensitive   = true
}

output "ssh_command" {
  value       = "ssh ${var.admin_username}@${azurerm_network_interface.this.private_ip_address}"
  description = "SSH command to connect to the VM (use Azure Bastion or VPN)"
  sensitive   = true
}

# =============================================================================
# Availability Outputs
# =============================================================================

output "availability_zone" {
  value       = azurerm_linux_virtual_machine.this.zone
  description = "The availability zone of the VM"
}

output "availability_set_id" {
  value       = azurerm_linux_virtual_machine.this.availability_set_id
  description = "The availability set ID of the VM"
}

# =============================================================================
# Disk Outputs
# =============================================================================

output "os_disk_id" {
  value       = azurerm_linux_virtual_machine.this.os_disk[0].name
  description = "The OS disk name"
}

output "data_disk_ids" {
  value       = [for disk in azurerm_managed_disk.data : disk.id]
  description = "The IDs of all data disks"
}

# =============================================================================
# Tagging Outputs
# =============================================================================

output "tags" {
  value       = azurerm_linux_virtual_machine.this.tags
  description = "The tags applied to the VM"
}

# =============================================================================
# VM Extensions Outputs
# =============================================================================

output "azure_monitor_agent_id" {
  value       = try(azurerm_virtual_machine_extension.azure_monitor[0].id, null)
  description = "The ID of the Azure Monitor Agent extension"
}

output "dependency_agent_id" {
  value       = try(azurerm_virtual_machine_extension.dependency_agent[0].id, null)
  description = "The ID of the Dependency Agent extension"
}

output "custom_script_extension_id" {
  value       = try(azurerm_virtual_machine_extension.custom_script[0].id, null)
  description = "The ID of the Custom Script extension"
}
