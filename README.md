<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
module "linux_vm" {
  source = "../.."

  contact     = "admin@company.com"
  environment = "dev"
  location    = "centralus"
  repository  = "infrastructure"
  workload    = "app"

  resource_group_name = "rg-app-cu-dev-kmi-0"
  subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-hub/subnets/subnet-app"
  vm_size             = "Standard_D2s_v3"
  admin_username      = "azureuser"
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

  boot_diagnostics_storage_account_uri = "https://stdiagcu0.blob.core.windows.net/"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.4 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | ../terraform-terraform-namer | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.azure_monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.custom_script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.dependency_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The admin username for the Linux VM | `string` | n/a | yes |
| <a name="input_availability_set_id"></a> [availability\_set\_id](#input\_availability\_set\_id) | The ID of the availability set. Mutually exclusive with availability\_zone | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zone for the VM (e.g., '1', '2', '3'). Mutually exclusive with availability\_set\_id | `string` | `null` | no |
| <a name="input_boot_diagnostics_storage_account_uri"></a> [boot\_diagnostics\_storage\_account\_uri](#input\_boot\_diagnostics\_storage\_account\_uri) | The URI of the storage account for boot diagnostics | `string` | n/a | yes |
| <a name="input_contact"></a> [contact](#input\_contact) | Contact email for resource ownership and notifications | `string` | n/a | yes |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | Cloud-init custom data for initial VM configuration. Will be base64 encoded automatically | `string` | `null` | no |
| <a name="input_custom_script_command"></a> [custom\_script\_command](#input\_custom\_script\_command) | Command to execute for Custom Script Extension | `string` | `null` | no |
| <a name="input_custom_script_file_uris"></a> [custom\_script\_file\_uris](#input\_custom\_script\_file\_uris) | List of file URIs for Custom Script Extension | `list(string)` | `null` | no |
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | List of data disks to attach to the VM | <pre>list(object({<br/>    disk_size_gb         = number<br/>    lun                  = number<br/>    caching              = string<br/>    storage_account_type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_disable_password_authentication"></a> [disable\_password\_authentication](#input\_disable\_password\_authentication) | Disable password authentication (SSH key only). Recommended: true | `bool` | `true` | no |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | The ID of the Disk Encryption Set for customer-managed keys (CMK) | `string` | `null` | no |
| <a name="input_enable_azure_monitor_agent"></a> [enable\_azure\_monitor\_agent](#input\_enable\_azure\_monitor\_agent) | Enable Azure Monitor Agent extension | `bool` | `true` | no |
| <a name="input_enable_custom_script_extension"></a> [enable\_custom\_script\_extension](#input\_enable\_custom\_script\_extension) | Enable Custom Script Extension for bootstrap scripts | `bool` | `false` | no |
| <a name="input_enable_dependency_agent"></a> [enable\_dependency\_agent](#input\_enable\_dependency\_agent) | Enable Dependency Agent extension (requires Azure Monitor Agent) | `bool` | `false` | no |
| <a name="input_enable_managed_identity"></a> [enable\_managed\_identity](#input\_enable\_managed\_identity) | Enable managed identity for the VM | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, stg, prd, etc.) | `string` | n/a | yes |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user-assigned managed identity IDs (required if identity\_type includes UserAssigned) | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of managed identity (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned) | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be deployed | `string` | n/a | yes |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | The caching type for the OS disk | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The size of the OS disk in GB. If not specified, uses image default | `number` | `null` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The storage account type for the OS disk | `string` | `"Premium_LRS"` | no |
| <a name="input_os_image_offer"></a> [os\_image\_offer](#input\_os\_image\_offer) | The offer of the OS image | `string` | `"0001-com-ubuntu-server-jammy"` | no |
| <a name="input_os_image_publisher"></a> [os\_image\_publisher](#input\_os\_image\_publisher) | The publisher of the OS image | `string` | `"Canonical"` | no |
| <a name="input_os_image_sku"></a> [os\_image\_sku](#input\_os\_image\_sku) | The SKU of the OS image (Ubuntu 22.04 LTS, RHEL 9, etc.) | `string` | `"22_04-lts-gen2"` | no |
| <a name="input_os_image_version"></a> [os\_image\_version](#input\_os\_image\_version) | The version of the OS image | `string` | `"latest"` | no |
| <a name="input_patch_assessment_mode"></a> [patch\_assessment\_mode](#input\_patch\_assessment\_mode) | The patch assessment mode (AutomaticByPlatform or ImageDefault) | `string` | `"ImageDefault"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | The patch mode for the VM (ImageDefault or AutomaticByPlatform) | `string` | `"ImageDefault"` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | The static private IP address for the VM. If not provided, dynamic allocation is used | `string` | `null` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | The ID of the public IP address to associate with the VM. Leave null for no public IP (recommended) | `string` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Source repository name for tracking and documentation | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Linux VM | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for authentication (RSA format, minimum 2048-bit) | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet where the network interface will be attached | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the virtual machine (e.g., Standard\_D2s\_v3, Standard\_B2ms) | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload or application name for resource identification | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The admin username for the VM |
| <a name="output_availability_set_id"></a> [availability\_set\_id](#output\_availability\_set\_id) | The availability set ID of the VM |
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | The availability zone of the VM |
| <a name="output_azure_monitor_agent_id"></a> [azure\_monitor\_agent\_id](#output\_azure\_monitor\_agent\_id) | The ID of the Azure Monitor Agent extension |
| <a name="output_computer_name"></a> [computer\_name](#output\_computer\_name) | The computer name of the Linux Virtual Machine |
| <a name="output_custom_script_extension_id"></a> [custom\_script\_extension\_id](#output\_custom\_script\_extension\_id) | The ID of the Custom Script extension |
| <a name="output_data_disk_ids"></a> [data\_disk\_ids](#output\_data\_disk\_ids) | The IDs of all data disks |
| <a name="output_dependency_agent_id"></a> [dependency\_agent\_id](#output\_dependency\_agent\_id) | The ID of the Dependency Agent extension |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | The Principal ID of the managed identity |
| <a name="output_identity_tenant_id"></a> [identity\_tenant\_id](#output\_identity\_tenant\_id) | The Tenant ID of the managed identity |
| <a name="output_location"></a> [location](#output\_location) | The Azure region where the VM is deployed |
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | The ID of the network interface |
| <a name="output_os_disk_id"></a> [os\_disk\_id](#output\_os\_disk\_id) | The OS disk name |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address of the VM |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | All private IP addresses of the network interface |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The resource group name |
| <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command) | SSH command to connect to the VM (use Azure Bastion or VPN) |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags applied to the VM |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The ID of the Linux Virtual Machine |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the Linux Virtual Machine |
| <a name="output_vm_size"></a> [vm\_size](#output\_vm\_size) | The size of the Linux Virtual Machine |
<!-- END_TF_DOCS -->