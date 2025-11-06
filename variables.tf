# =============================================================================
# Required Variables - Resource Group and Location
# =============================================================================

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Linux VM"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty"
  }
}

# =============================================================================
# Required Variables - Network Configuration
# =============================================================================

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the network interface will be attached"

  validation {
    condition     = can(regex("^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+/subnets/.+$", var.subnet_id))
    error_message = "Subnet ID must be a valid Azure subnet resource ID"
  }
}

# =============================================================================
# Required Variables - VM Configuration
# =============================================================================

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine (e.g., Standard_D2s_v3, Standard_B2ms)"

  validation {
    condition     = length(var.vm_size) > 0
    error_message = "VM size cannot be empty"
  }
}

variable "admin_username" {
  type        = string
  description = "The admin username for the Linux VM"

  validation {
    condition     = length(var.admin_username) >= 1 && length(var.admin_username) <= 32
    error_message = "Admin username must be 1-32 characters"
  }

  validation {
    condition     = !contains(["root", "admin", "administrator", "user", "guest", "test"], lower(var.admin_username))
    error_message = "Admin username cannot be a reserved name (root, admin, administrator, user, guest, test)"
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for authentication (RSA format, minimum 2048-bit)"

  validation {
    condition     = can(regex("^ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3}( [^@]+@[^@]+)?$", var.ssh_public_key))
    error_message = "SSH public key must be in valid ssh-rsa format"
  }
}

# =============================================================================
# Required Variables - Boot Diagnostics
# =============================================================================

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "The URI of the storage account for boot diagnostics"

  validation {
    condition     = can(regex("^https://.*\\.blob\\.core\\.windows\\.net/$", var.boot_diagnostics_storage_account_uri))
    error_message = "Boot diagnostics storage account URI must be a valid Azure blob storage URI"
  }
}

# =============================================================================
# Optional Variables - Network Configuration
# =============================================================================

variable "private_ip_address" {
  type        = string
  description = "The static private IP address for the VM. If not provided, dynamic allocation is used"
  default     = null
}

variable "public_ip_address_id" {
  type        = string
  description = "The ID of the public IP address to associate with the VM. Leave null for no public IP (recommended)"
  default     = null
}

# =============================================================================
# Optional Variables - SSH Configuration
# =============================================================================

variable "disable_password_authentication" {
  type        = bool
  description = "Disable password authentication (SSH key only). Recommended: true"
  default     = true
}

# =============================================================================
# Optional Variables - OS Image Configuration
# =============================================================================

variable "os_image_publisher" {
  type        = string
  description = "The publisher of the OS image"
  default     = "Canonical"
}

variable "os_image_offer" {
  type        = string
  description = "The offer of the OS image"
  default     = "0001-com-ubuntu-server-jammy"
}

variable "os_image_sku" {
  type        = string
  description = "The SKU of the OS image (Ubuntu 22.04 LTS, RHEL 9, etc.)"
  default     = "22_04-lts-gen2"

  validation {
    condition = contains([
      # Ubuntu
      "22_04-lts-gen2", "22_04-lts", "20_04-lts-gen2", "20_04-lts",
      # RHEL
      "9-lvm-gen2", "9_2-gen2", "8-lvm-gen2", "8_8-gen2",
      # CentOS
      "7_9-gen2", "7_9", "8_5-gen2",
      # Debian
      "11-gen2", "11", "10-gen2", "10",
      # SLES
      "gen2-15-sp4", "gen2-15-sp3", "15-sp4", "15-sp3"
    ], var.os_image_sku)
    error_message = "OS image SKU must be a supported Linux distribution version"
  }
}

variable "os_image_version" {
  type        = string
  description = "The version of the OS image"
  default     = "latest"
}

# =============================================================================
# Optional Variables - OS Disk Configuration
# =============================================================================

variable "os_disk_caching" {
  type        = string
  description = "The caching type for the OS disk"
  default     = "ReadWrite"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "OS disk caching must be None, ReadOnly, or ReadWrite"
  }
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "The storage account type for the OS disk"
  default     = "Premium_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_storage_account_type)
    error_message = "OS disk storage account type must be a valid Azure managed disk type"
  }
}

variable "os_disk_size_gb" {
  type        = number
  description = "The size of the OS disk in GB. If not specified, uses image default"
  default     = null

  validation {
    condition     = var.os_disk_size_gb == null || (var.os_disk_size_gb >= 30 && var.os_disk_size_gb <= 4095)
    error_message = "OS disk size must be between 30 and 4095 GB"
  }
}

variable "disk_encryption_set_id" {
  type        = string
  description = "The ID of the Disk Encryption Set for customer-managed keys (CMK)"
  default     = null
}

# =============================================================================
# Optional Variables - Data Disks
# =============================================================================

variable "data_disks" {
  type = list(object({
    disk_size_gb         = number
    lun                  = number
    caching              = string
    storage_account_type = string
  }))
  description = "List of data disks to attach to the VM"
  default     = []

  validation {
    condition     = alltrue([for disk in var.data_disks : disk.disk_size_gb >= 1 && disk.disk_size_gb <= 32767])
    error_message = "Data disk size must be between 1 and 32767 GB"
  }

  validation {
    condition     = alltrue([for disk in var.data_disks : contains(["None", "ReadOnly", "ReadWrite"], disk.caching)])
    error_message = "Data disk caching must be None, ReadOnly, or ReadWrite"
  }

  validation {
    condition     = alltrue([for disk in var.data_disks : contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "UltraSSD_LRS", "StandardSSD_ZRS", "Premium_ZRS"], disk.storage_account_type)])
    error_message = "Data disk storage account type must be valid"
  }
}

# =============================================================================
# Optional Variables - Availability Configuration
# =============================================================================

variable "availability_zone" {
  type        = string
  description = "The availability zone for the VM (e.g., '1', '2', '3'). Mutually exclusive with availability_set_id"
  default     = null

  validation {
    condition     = var.availability_zone == null || contains(["1", "2", "3"], var.availability_zone)
    error_message = "Availability zone must be '1', '2', or '3'"
  }
}

variable "availability_set_id" {
  type        = string
  description = "The ID of the availability set. Mutually exclusive with availability_zone"
  default     = null
}

# =============================================================================
# Optional Variables - Identity Configuration
# =============================================================================

variable "enable_managed_identity" {
  type        = bool
  description = "Enable managed identity for the VM"
  default     = true
}

variable "identity_type" {
  type        = string
  description = "The type of managed identity (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned)"
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Identity type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned"
  }
}

variable "identity_ids" {
  type        = list(string)
  description = "List of user-assigned managed identity IDs (required if identity_type includes UserAssigned)"
  default     = []
}

# =============================================================================
# Optional Variables - Cloud-Init Configuration
# =============================================================================

variable "custom_data" {
  type        = string
  description = "Cloud-init custom data for initial VM configuration. Will be base64 encoded automatically"
  default     = null
}

# =============================================================================
# Optional Variables - Patching Configuration
# =============================================================================

variable "patch_mode" {
  type        = string
  description = "The patch mode for the VM (ImageDefault or AutomaticByPlatform)"
  default     = "ImageDefault"

  validation {
    condition     = contains(["ImageDefault", "AutomaticByPlatform"], var.patch_mode)
    error_message = "Patch mode must be ImageDefault or AutomaticByPlatform"
  }
}

variable "patch_assessment_mode" {
  type        = string
  description = "The patch assessment mode (AutomaticByPlatform or ImageDefault)"
  default     = "ImageDefault"

  validation {
    condition     = contains(["AutomaticByPlatform", "ImageDefault"], var.patch_assessment_mode)
    error_message = "Patch assessment mode must be AutomaticByPlatform or ImageDefault"
  }
}

# =============================================================================
# Optional Variables - VM Extensions
# =============================================================================

variable "enable_azure_monitor_agent" {
  type        = bool
  description = "Enable Azure Monitor Agent extension"
  default     = true
}

variable "enable_dependency_agent" {
  type        = bool
  description = "Enable Dependency Agent extension (requires Azure Monitor Agent)"
  default     = false
}

variable "enable_custom_script_extension" {
  type        = bool
  description = "Enable Custom Script Extension for bootstrap scripts"
  default     = false
}

variable "custom_script_file_uris" {
  type        = list(string)
  description = "List of file URIs for Custom Script Extension"
  default     = null
}

variable "custom_script_command" {
  type        = string
  description = "Command to execute for Custom Script Extension"
  default     = null
}

# =============================================================================
# Optional Variables - Diagnostics Configuration
# =============================================================================

variable "enable_diagnostics" {
  description = "Enable diagnostic settings for the Virtual Machine"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics workspace for diagnostics (required if enable_diagnostics = true)"
  type        = string
  default     = null
}

variable "log_analytics_destination_type" {
  description = "The destination type for diagnostic settings (Dedicated or AzureDiagnostics)"
  type        = string
  default     = "Dedicated"

  validation {
    condition     = contains(["Dedicated", "AzureDiagnostics"], var.log_analytics_destination_type)
    error_message = "log_analytics_destination_type must be either 'Dedicated' or 'AzureDiagnostics'"
  }
}

# =============================================================================
# Naming Variables (terraform-namer)
# =============================================================================

variable "contact" {
  type        = string
  description = "Contact email for resource ownership and notifications"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.contact))
    error_message = "Contact must be a valid email address"
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, stg, prd, etc.)"

  validation {
    condition     = contains(["dev", "stg", "prd", "sbx", "tst", "ops", "hub"], var.environment)
    error_message = "Environment must be one of: dev, stg, prd, sbx, tst, ops, hub"
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"

  validation {
    condition = contains([
      "centralus", "eastus", "eastus2", "westus", "westus2", "westus3",
      "northcentralus", "southcentralus", "westcentralus",
      "canadacentral", "canadaeast",
      "brazilsouth",
      "northeurope", "westeurope",
      "uksouth", "ukwest",
      "francecentral", "francesouth",
      "germanywestcentral",
      "switzerlandnorth",
      "norwayeast",
      "eastasia", "southeastasia",
      "japaneast", "japanwest",
      "australiaeast", "australiasoutheast",
      "centralindia", "southindia", "westindia"
    ], var.location)
    error_message = "Location must be a valid Azure region"
  }
}

variable "repository" {
  type        = string
  description = "Source repository name for tracking and documentation"

  validation {
    condition     = length(var.repository) > 0
    error_message = "Repository name cannot be empty"
  }
}

variable "workload" {
  type        = string
  description = "Workload or application name for resource identification"

  validation {
    condition     = length(var.workload) > 0 && length(var.workload) <= 20
    error_message = "Workload name must be 1-20 characters"
  }
}
