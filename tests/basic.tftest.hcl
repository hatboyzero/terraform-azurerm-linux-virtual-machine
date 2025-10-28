# =============================================================================
# Basic Functionality Tests
# =============================================================================
#
# These tests validate core module functionality using plan-only commands.
# No Azure resources are created, ensuring fast and cost-free execution.
#
# Note: With `command = plan`, output values are unknown until apply.
# These tests verify that configurations are valid and plans succeed.
#

# Configure the Azure Provider for testing
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Test: Default configuration with minimum required inputs
run "test_basic_creation" {
  command = plan

  variables {
    # Required terraform-namer inputs
    contact     = "test@example.com"
    environment = "dev"
    location    = "centralus"
    repository  = "test-repo"
    workload    = "testapp"

    # Required VM configuration
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"
  }

  # Plan should succeed with default configuration
}

# Test: Production configuration with different environment
run "test_production_configuration" {
  command = plan

  variables {
    contact                              = "ops@company.com"
    environment                          = "prd"
    location                             = "eastus2"
    repository                           = "infrastructure"
    workload                             = "webapp"
    resource_group_name                  = "rg-webapp-eu-prd-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/subnet-app"
    vm_size                              = "Standard_D4s_v3"
    admin_username                       = "prodadmin"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagprod.blob.core.windows.net/"
  }

  # Plan should succeed with production configuration
}

# Test: RHEL Linux distribution
run "test_rhel_distribution" {
  command = plan

  variables {
    contact                              = "test@example.com"
    environment                          = "dev"
    location                             = "centralus"
    repository                           = "test-repo"
    workload                             = "rhel"
    resource_group_name                  = "rg-test-cu-dev-kmi-0"
    subnet_id                            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/subnet-test"
    vm_size                              = "Standard_D2s_v3"
    admin_username                       = "azureuser"
    ssh_public_key                       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdJQtO2xXq0yM/FGvlJrMVReb3IhEytzmsLN2yttmTujwjwajTd6ypTK0kP3QoIBF6E5zI47uTQPP6d2IayylDnw79lyED6naKmKVAylOwwuz84pp7zu46KvhN0S5JP9aOrSQMp8vVH4vhCi9sApzEVqbSZ+FwTMeZQRRxscDeZzURVty6rD2x0ceF/Mqa+wirRfC/OgAMXKJAtOUe4wgPIUIrXwKkRpkfLSSmDwL1UivUKLX31NkzHDXAnBknKev3JyYbyykHdGqyMH2K0IfxCE/6CN8gtQoWxm/rQz8gZjEO3AQq63D12CeymZzb01fN4o02tLWxrPoSTEkdewtr test@example.com"
    boot_diagnostics_storage_account_uri = "https://stdiagtest.blob.core.windows.net/"

    # RHEL 9 configuration
    os_image_publisher = "RedHat"
    os_image_offer     = "RHEL"
    os_image_sku       = "9-lvm-gen2"
  }

  # Plan should succeed with RHEL distribution
}

# Test: With availability zone
run "test_availability_zone" {
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

    # Availability zone configuration
    availability_zone = "1"
  }

  # Plan should succeed with availability zone
}

# Test: With data disks
run "test_data_disks" {
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

    # Data disk configuration
    data_disks = [
      {
        disk_size_gb         = 128
        lun                  = 0
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
      },
      {
        disk_size_gb         = 256
        lun                  = 1
        caching              = "ReadOnly"
        storage_account_type = "StandardSSD_LRS"
      }
    ]
  }

  # Plan should succeed with multiple data disks
}

# Test: Azure Monitor Agent enabled (default)
run "test_azure_monitor_agent_enabled" {
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

    # Azure Monitor Agent enabled by default
    enable_azure_monitor_agent = true
  }

  # Plan should succeed with Azure Monitor Agent
}

# Test: Azure Monitor Agent disabled
run "test_azure_monitor_agent_disabled" {
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

    enable_azure_monitor_agent = false
  }

  # Plan should succeed without Azure Monitor Agent
}

# Test: Dependency Agent enabled
run "test_dependency_agent_enabled" {
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

    enable_azure_monitor_agent = true
    enable_dependency_agent    = true
  }

  # Plan should succeed with Dependency Agent
}

# Test: Managed identity enabled (default)
run "test_managed_identity_system_assigned" {
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
    identity_type           = "SystemAssigned"
  }

  # Plan should succeed with system-assigned managed identity
}

# Test: Static private IP address
run "test_static_private_ip" {
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

    private_ip_address = "10.0.1.10"
  }

  # Plan should succeed with static private IP
}

# Test: Custom OS disk configuration
run "test_custom_os_disk" {
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

    os_disk_size_gb              = 128
    os_disk_caching              = "ReadOnly"
    os_disk_storage_account_type = "StandardSSD_LRS"
  }

  # Plan should succeed with custom OS disk configuration
}

# Test: Custom patching configuration
run "test_custom_patching" {
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

    patch_mode            = "AutomaticByPlatform"
    patch_assessment_mode = "AutomaticByPlatform"
  }

  # Plan should succeed with custom patching configuration
}
