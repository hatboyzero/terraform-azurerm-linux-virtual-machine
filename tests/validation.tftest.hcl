# =============================================================================
# Input Validation Tests
# =============================================================================
#
# These tests validate that input variables are properly constrained and
# that invalid inputs trigger appropriate validation errors.
#

# Configure the Azure Provider for testing
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# =============================================================================
# Naming Variables Validation (terraform-namer)
# =============================================================================

# Test: Invalid environment value
run "test_invalid_environment" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "invalid"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.environment,
  ]
}

# Test: Invalid location value
run "test_invalid_location" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "invalid-region"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.location,
  ]
}

# Test: Invalid contact email format
run "test_invalid_contact_format" {
  command = plan

  variables {
    contact                              = "not-an-email"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.contact,
  ]
}

# Test: Empty repository name
run "test_empty_repository" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = ""
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.repository,
  ]
}

# Test: Workload name too long
run "test_workload_too_long" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "thisworkloadnameiswaytoolongandexceedsthelimit"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.workload,
  ]
}

# =============================================================================
# VM Configuration Validation
# =============================================================================

# Test: Empty resource group name
run "test_empty_resource_group" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = ""
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.resource_group_name,
  ]
}

# Test: Invalid subnet ID format
run "test_invalid_subnet_id" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "not-a-valid-subnet-id"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.subnet_id,
  ]
}

# Test: Empty VM size
run "test_empty_vm_size" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = ""
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.vm_size,
  ]
}

# Test: Admin username too long
run "test_admin_username_too_long" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "thisusernameiswaytoolongandexceeds32characters"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.admin_username,
  ]
}

# Test: Admin username is reserved name (root)
run "test_admin_username_reserved_root" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "root"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.admin_username,
  ]
}

# Test: Admin username is reserved name (admin)
run "test_admin_username_reserved_admin" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "admin"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.admin_username,
  ]
}

# Test: Invalid SSH public key format
run "test_invalid_ssh_key_format" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "not-a-valid-ssh-key"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  expect_failures = [
    var.ssh_public_key,
  ]
}

# Test: Invalid boot diagnostics storage URI
run "test_invalid_boot_diagnostics_uri" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "not-a-valid-uri"
  }

  expect_failures = [
    var.boot_diagnostics_storage_account_uri,
  ]
}

# =============================================================================
# OS Image Configuration Validation
# =============================================================================

# Test: Invalid OS image SKU
run "test_invalid_os_image_sku" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    os_image_sku = "invalid-sku"
  }

  expect_failures = [
    var.os_image_sku,
  ]
}

# =============================================================================
# Disk Configuration Validation
# =============================================================================

# Test: Invalid OS disk caching option
run "test_invalid_os_disk_caching" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    os_disk_caching = "Invalid"
  }

  expect_failures = [
    var.os_disk_caching,
  ]
}

# Test: Invalid OS disk storage account type
run "test_invalid_os_disk_storage_type" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    os_disk_storage_account_type = "Invalid_LRS"
  }

  expect_failures = [
    var.os_disk_storage_account_type,
  ]
}

# Test: OS disk size below minimum (30 GB)
run "test_os_disk_size_below_minimum" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    os_disk_size_gb = 20
  }

  expect_failures = [
    var.os_disk_size_gb,
  ]
}

# Test: OS disk size above maximum (4095 GB)
run "test_os_disk_size_above_maximum" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    os_disk_size_gb = 5000
  }

  expect_failures = [
    var.os_disk_size_gb,
  ]
}

# Test: Data disk size below minimum (1 GB)
run "test_data_disk_size_below_minimum" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    data_disks = [
      {
        disk_size_gb         = 0
        lun                  = 0
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
      }
    ]
  }

  expect_failures = [
    var.data_disks,
  ]
}

# Test: Data disk size above maximum (32767 GB)
run "test_data_disk_size_above_maximum" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    data_disks = [
      {
        disk_size_gb         = 40000
        lun                  = 0
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
      }
    ]
  }

  expect_failures = [
    var.data_disks,
  ]
}

# Test: Invalid data disk caching option
run "test_invalid_data_disk_caching" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    data_disks = [
      {
        disk_size_gb         = 128
        lun                  = 0
        caching              = "Invalid"
        storage_account_type = "Premium_LRS"
      }
    ]
  }

  expect_failures = [
    var.data_disks,
  ]
}

# Test: Invalid data disk storage account type
run "test_invalid_data_disk_storage_type" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    data_disks = [
      {
        disk_size_gb         = 128
        lun                  = 0
        caching              = "ReadWrite"
        storage_account_type = "Invalid_LRS"
      }
    ]
  }

  expect_failures = [
    var.data_disks,
  ]
}

# =============================================================================
# Availability Configuration Validation
# =============================================================================

# Test: Invalid availability zone
run "test_invalid_availability_zone" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    availability_zone = "4"
  }

  expect_failures = [
    var.availability_zone,
  ]
}

# =============================================================================
# Identity Configuration Validation
# =============================================================================

# Test: Invalid identity type
run "test_invalid_identity_type" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    enable_managed_identity = true
    identity_type           = "Invalid"
  }

  expect_failures = [
    var.identity_type,
  ]
}

# =============================================================================
# Patching Configuration Validation
# =============================================================================

# Test: Invalid patch mode
run "test_invalid_patch_mode" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    patch_mode = "Invalid"
  }

  expect_failures = [
    var.patch_mode,
  ]
}

# Test: Invalid patch assessment mode
run "test_invalid_patch_assessment_mode" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "testapp"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    patch_assessment_mode = "Invalid"
  }

  expect_failures = [
    var.patch_assessment_mode,
  ]
}
