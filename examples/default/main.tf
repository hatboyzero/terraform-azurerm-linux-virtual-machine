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
