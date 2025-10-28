# =============================================================================
# Module: Azure Linux Virtual Machine
# =============================================================================
#
# Purpose:
#   This module creates and manages Azure Linux Virtual Machines with
#   comprehensive security, monitoring, and operational features.
#
# Features:
#   - Multiple Linux distributions (Ubuntu, RHEL, CentOS, Debian, SLES)
#   - SSH public key authentication (password auth disabled)
#   - Configurable VM sizes (Standard_B2s to Standard_D32s_v3+)
#   - Network interface with private IP (no public IP by default)
#   - Encrypted managed disks (OS disk + optional data disks)
#   - Boot diagnostics with storage account
#   - Optional VM extensions (Azure Monitor, Dependency Agent, Custom Script)
#   - Availability zones or availability sets
#   - Cloud-init custom data support
#   - Consistent naming and tagging via terraform-namer
#
# Resources Created:
#   - azurerm_network_interface
#   - azurerm_linux_virtual_machine
#   - azurerm_managed_disk (optional data disks)
#   - azurerm_virtual_machine_data_disk_attachment (optional)
#   - azurerm_virtual_machine_extension (optional monitoring/scripts)
#
# Dependencies:
#   - terraform-terraform-namer (required)
#   - Existing subnet for network interface
#   - Existing storage account for boot diagnostics
#
# Usage:
#   module "linux_vm" {
#     source = "path/to/terraform-azurerm-linux-virtual-machine"
#
#     contact     = "admin@company.com"
#     environment = "dev"
#     location    = "centralus"
#     repository  = "infrastructure"
#     workload    = "app"
#
#     resource_group_name = "rg-app-cu-dev-kmi-0"
#     subnet_id           = "/subscriptions/.../subnets/subnet-app"
#     vm_size             = "Standard_D2s_v3"
#     admin_username      = "azureuser"
#     ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EA..."
#
#     boot_diagnostics_storage_account_uri = "https://stdiag.blob.core.windows.net/"
#   }
#
# Security Considerations:
#   - Store SSH private keys securely (never commit to code)
#   - Use Azure Key Vault for SSH key storage
#   - Configure NSG rules on the subnet
#   - Enable Azure Defender for Servers
#   - Enable Azure Backup for production VMs
#   - Use managed identity instead of stored credentials where possible
#   - Access VMs via Azure Bastion, not public IPs
#
# =============================================================================

# =============================================================================
# Section: Naming and Tagging
# =============================================================================

module "naming" {
  source = "../terraform-terraform-namer"

  contact     = var.contact
  environment = var.environment
  location    = var.location
  repository  = var.repository
  workload    = var.workload
}

# =============================================================================
# Section: Network Interface
# =============================================================================

resource "azurerm_network_interface" "this" {
  name                = "nic-${module.naming.resource_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip_address_id
  }

  tags = module.naming.tags
}

# =============================================================================
# Section: Linux Virtual Machine
# =============================================================================

resource "azurerm_linux_virtual_machine" "this" {
  name                = "vm-${module.naming.resource_suffix_vm}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  availability_set_id = var.availability_set_id
  zone                = var.availability_zone

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  # SSH Configuration
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Disable password authentication (SSH only)
  disable_password_authentication = var.disable_password_authentication

  # OS Disk Configuration
  os_disk {
    name                 = "osdisk-${module.naming.resource_suffix_vm}"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  # OS Image Configuration
  source_image_reference {
    publisher = var.os_image_publisher
    offer     = var.os_image_offer
    sku       = var.os_image_sku
    version   = var.os_image_version
  }

  # Boot Diagnostics
  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account_uri
  }

  # Identity Configuration
  dynamic "identity" {
    for_each = var.enable_managed_identity ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type != "SystemAssigned" ? var.identity_ids : null
    }
  }

  # Cloud-init Custom Data
  custom_data = var.custom_data != null ? base64encode(var.custom_data) : null

  # Patching Configuration
  patch_mode            = var.patch_mode
  patch_assessment_mode = var.patch_assessment_mode

  tags = module.naming.tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to custom data to prevent unnecessary replacements
      custom_data,
    ]
  }
}

# =============================================================================
# Section: Data Disks (Optional)
# =============================================================================

resource "azurerm_managed_disk" "data" {
  for_each = { for idx, disk in var.data_disks : idx => disk }

  name                 = "datadisk-${module.naming.resource_suffix_vm}-${each.key}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb
  disk_encryption_set_id = var.disk_encryption_set_id

  zone = var.availability_zone

  tags = module.naming.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = { for idx, disk in var.data_disks : idx => disk }

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.caching
}

# =============================================================================
# Section: VM Extensions - Azure Monitor Agent (Optional)
# =============================================================================

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  count = var.enable_azure_monitor_agent ? 1 : 0

  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.21"
  auto_upgrade_minor_version = true

  tags = module.naming.tags
}

# =============================================================================
# Section: VM Extensions - Dependency Agent (Optional)
# =============================================================================

resource "azurerm_virtual_machine_extension" "dependency_agent" {
  count = var.enable_dependency_agent ? 1 : 0

  name                       = "DependencyAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true

  tags = module.naming.tags

  depends_on = [
    azurerm_virtual_machine_extension.azure_monitor
  ]
}

# =============================================================================
# Section: VM Extensions - Custom Script Extension (Optional)
# =============================================================================

resource "azurerm_virtual_machine_extension" "custom_script" {
  count = var.enable_custom_script_extension && var.custom_script_file_uris != null ? 1 : 0

  name                       = "CustomScriptExtension"
  virtual_machine_id         = azurerm_linux_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    fileUris = var.custom_script_file_uris
  })

  protected_settings = jsonencode({
    commandToExecute = var.custom_script_command
  })

  tags = module.naming.tags
}
