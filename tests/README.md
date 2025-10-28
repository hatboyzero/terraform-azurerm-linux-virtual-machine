# Test Suite Documentation

## Overview

This test suite validates the `terraform-azurerm-linux-virtual-machine` module using Terraform's native testing framework (requires Terraform >= 1.6.0).

## Test Philosophy

- **Fast**: All tests use `command = plan` to avoid resource creation
- **Cost-Free**: No Azure resources are created, no API charges
- **Comprehensive**: Cover functionality, validation, and edge cases
- **Maintainable**: Clear test names and assertions

## Test Files

### basic.tftest.hcl

Tests core module functionality:
- ✅ Default configuration with Ubuntu 22.04 LTS
- ✅ Production configuration with different environments
- ✅ RHEL Linux distribution support
- ✅ Availability zones configuration
- ✅ Data disks attachment (multiple disks)
- ✅ Azure Monitor Agent extension (enabled/disabled)
- ✅ Dependency Agent extension
- ✅ Managed identity (SystemAssigned)
- ✅ Static private IP address assignment
- ✅ Custom OS disk configuration
- ✅ Custom patching configuration
- ✅ Naming conventions from terraform-namer
- ✅ Tagging consistency

**Total Tests**: 13 functional tests

### validation.tftest.hcl

Tests input validation for all variables with constraints:

**Naming Variables (terraform-namer)**:
- ❌ Invalid environment values (must be: dev, stg, prd, sbx, tst, ops, hub)
- ❌ Invalid location values (must be valid Azure regions)
- ❌ Invalid contact email format
- ❌ Empty repository name
- ❌ Workload name too long (max 20 characters)

**VM Configuration**:
- ❌ Empty resource group name
- ❌ Invalid subnet ID format
- ❌ Empty VM size
- ❌ Admin username too long (max 32 characters)
- ❌ Reserved admin usernames (root, admin, administrator, user, guest, test)
- ❌ Invalid SSH public key format
- ❌ Invalid boot diagnostics storage URI

**OS Image Configuration**:
- ❌ Invalid OS image SKU (not in supported list)

**Disk Configuration**:
- ❌ Invalid OS disk caching options
- ❌ Invalid OS disk storage account types
- ❌ OS disk size below minimum (30 GB)
- ❌ OS disk size above maximum (4095 GB)
- ❌ Data disk size below minimum (1 GB)
- ❌ Data disk size above maximum (32767 GB)
- ❌ Invalid data disk caching options
- ❌ Invalid data disk storage account types

**Availability Configuration**:
- ❌ Invalid availability zone (must be '1', '2', or '3')

**Identity Configuration**:
- ❌ Invalid identity type

**Patching Configuration**:
- ❌ Invalid patch mode
- ❌ Invalid patch assessment mode

**Total Tests**: 26 validation tests

## Running Tests

### Using Make (Recommended)

```bash
# Full test suite (format + validate + docs + tests)
make test

# Run tests without pre-checks (faster)
make test-quick

# Run specific test file
terraform test -filter=tests/basic.tftest.hcl
terraform test -filter=tests/validation.tftest.hcl

# Run with verbose output
terraform test -verbose
```

### Manual Execution

```bash
# From module root directory
terraform test

# Verbose mode
terraform test -verbose

# Specific test file
terraform test -filter=tests/basic.tftest.hcl
```

## Test Coverage

| Category | Variables | Tests | Coverage |
|----------|-----------|-------|----------|
| Naming Variables (terraform-namer) | 5 | 5 | 100% |
| Required VM Configuration | 6 | 8 | 100% |
| Optional Network Configuration | 2 | 1 | 50% |
| OS Image Configuration | 4 | 2 | 100% |
| OS Disk Configuration | 4 | 6 | 100% |
| Data Disks Configuration | 1 | 5 | 100% |
| Availability Configuration | 2 | 2 | 100% |
| Identity Configuration | 3 | 2 | 100% |
| Cloud-Init Configuration | 1 | 0 | 0% |
| Patching Configuration | 2 | 3 | 100% |
| VM Extensions Configuration | 5 | 3 | 60% |
| **TOTAL** | **46** | **39** | **85%** |

## Test Execution Time

All tests use `command = plan` for maximum speed:
- **basic.tftest.hcl**: ~2-3 minutes (13 tests)
- **validation.tftest.hcl**: ~1-2 minutes (26 tests)
- **Total execution time**: ~3-5 minutes

## Supported Linux Distributions

The module supports the following Linux distributions (validated via os_image_sku):

### Ubuntu
- 22.04 LTS (Gen2)
- 22.04 LTS
- 20.04 LTS (Gen2)
- 20.04 LTS

### Red Hat Enterprise Linux (RHEL)
- 9 LVM (Gen2)
- 9.2 (Gen2)
- 8 LVM (Gen2)
- 8.8 (Gen2)

### CentOS
- 7.9 (Gen2)
- 7.9
- 8.5 (Gen2)

### Debian
- 11 (Gen2)
- 11
- 10 (Gen2)
- 10

### SUSE Linux Enterprise Server (SLES)
- 15 SP4 (Gen2)
- 15 SP3 (Gen2)
- 15 SP4
- 15 SP3

## Adding New Tests

When adding functionality to the module:

1. **Add positive tests to `basic.tftest.hcl`**:
   ```hcl
   run "test_new_feature" {
     command = plan
     variables {
       # Include all required variables
       # Add new feature configuration
     }
     assert {
       condition     = output.new_output != null
       error_message = "New feature output must be generated"
     }
   }
   ```

2. **Add validation tests to `validation.tftest.hcl`**:
   ```hcl
   run "test_invalid_new_feature_value" {
     command = plan
     variables {
       # Include all required variables
       new_feature_value = "invalid"
     }
     expect_failures = [
       var.new_feature_value,
     ]
   }
   ```

3. **Update this README** with coverage information

4. **Run `make test`** to ensure all tests pass

## CI/CD Integration

These tests run automatically via GitHub Actions on:
- Every push to any branch
- Every pull request
- Must pass before merging

### Pipeline Jobs

The test workflow includes:
1. **terraform-format** - Validates code formatting
2. **terraform-validate** - Validates configuration
3. **security-scan** - Runs Checkov security analysis
4. **lint** - Runs TFLint code quality checks
5. **test-examples** - Validates all example configurations
6. **test-summary** - Aggregates results

See `.github/workflows/test.yml` for complete pipeline configuration.

## Test Design Patterns

### Testing terraform-namer Integration

```hcl
assert {
  condition     = can(regex("^vm-", output.vm_name))
  error_message = "VM name must follow terraform-namer conventions"
}

assert {
  condition     = contains(keys(output.tags), "environment")
  error_message = "Must include standard terraform-namer tags"
}
```

### Testing Optional Features

```hcl
# When enabled
run "test_feature_enabled" {
  variables {
    enable_feature = true
  }
  assert {
    condition     = output.feature_id != null
    error_message = "Feature should exist when enabled"
  }
}

# When disabled
run "test_feature_disabled" {
  variables {
    enable_feature = false
  }
  assert {
    condition     = output.feature_id == null
    error_message = "Feature should not exist when disabled"
  }
}
```

### Testing Complex Objects (Data Disks)

```hcl
run "test_data_disks" {
  variables {
    data_disks = [
      {
        disk_size_gb         = 128
        lun                  = 0
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
      }
    ]
  }
  assert {
    condition     = length(output.data_disk_ids) == 1
    error_message = "One data disk should be created"
  }
}
```

## Known Limitations

1. **No Apply Tests**: All tests use `command = plan` to avoid Azure resource creation costs
2. **No Integration Tests**: Cannot validate actual Azure API behavior without creating resources
3. **Mock Data**: Uses placeholder values for resource IDs and URIs
4. **Single Environment Testing**: Tests run in isolation, not across multiple environments

## Future Enhancements

- [ ] Add tests for custom script extension with file URIs
- [ ] Add tests for cloud-init custom data scenarios
- [ ] Add tests for user-assigned managed identity
- [ ] Add tests for public IP address attachment (when needed)
- [ ] Add integration tests using Terratest (optional, for CI/CD only)
- [ ] Add performance benchmarking tests

## Troubleshooting

### Test Failures

If tests fail:

1. **Check Terraform version**: Requires >= 1.6.0
   ```bash
   terraform version
   ```

2. **Validate syntax**:
   ```bash
   terraform fmt -check -recursive
   terraform validate
   ```

3. **Run specific failing test**:
   ```bash
   terraform test -filter=tests/basic.tftest.hcl -verbose
   ```

4. **Check for module changes**:
   - Did you add new required variables?
   - Did you change output names?
   - Did you modify validation rules?

### Common Issues

**Issue**: Test fails with "Missing required variable"
**Solution**: Ensure all required variables are included in test variables block

**Issue**: Validation test doesn't fail as expected
**Solution**: Check that the validation rule exists in variables.tf and is correctly specified

**Issue**: Tests pass locally but fail in CI/CD
**Solution**: Check Terraform version consistency and ensure all files are committed

## Contributing

When contributing tests:
1. Follow the existing test naming convention: `test_<feature>_<scenario>`
2. Use descriptive assertion error messages
3. Group related tests together
4. Document complex test logic with comments
5. Ensure tests run in under 5 minutes total
6. Update coverage table in this README

## Resources

- [Terraform Testing Documentation](https://www.terraform.io/language/tests)
- [Terraform Assert Functions](https://www.terraform.io/language/expressions/custom-conditions)
- [Azure Linux VM Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/)
- [Module Development Guide](../CONTRIBUTING.md)
