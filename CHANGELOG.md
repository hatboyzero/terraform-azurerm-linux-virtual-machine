# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **BREAKING**: Updated azurerm provider from ~> 3.0 to ~> 4.0
  - Aligns with latest Azure provider features and improvements
  - Tested and validated with azurerm 4.52.0+
  - May require Terraform state refresh on upgrade
- **BREAKING**: Module dependencies now use Terraform Registry references instead of relative paths
  - `terraform-terraform-namer` → `app.terraform.io/infoex/namer/terraform` version `~> 0.1`
  - `terraform-azurerm-diagnostics` → `app.terraform.io/infoex/diagnostics/azurerm` version `~> 0.1`
  - Ensures proper version pinning and module registry best practices
  - **NOTE**: Requires modules to be published to Terraform Cloud/Enterprise registry

### Added
- **COMPLIANCE**: Diagnostic settings integration via terraform-azurerm-diagnostics module
  - Enables VM audit logging for PCI-DSS 10.2.2 and HIPAA §164.312(b) compliance
  - Configurable via `enable_diagnostics` variable (default: true)
  - Supports Dedicated or AzureDiagnostics table types
  - Provides Linux system logs, syslog, and performance metrics for security audits
  - **Requires**: terraform-azurerm-diagnostics module with azurerm ~> 4.0 support

## [0.0.1] - 2025-01-28

### Added
- Initial release of Azure Linux Virtual Machine module
- Support for multiple Linux distributions (Ubuntu, RHEL, CentOS, Debian, SLES)
- SSH public key authentication with password auth disabled by default
- Configurable VM sizes (Standard_B2s to Standard_D32s_v3+)
- Network interface with private IP (static or dynamic)
- Encrypted managed disks (OS disk + optional data disks)
- Boot diagnostics with storage account integration
- Optional VM extensions:
  - Azure Monitor Agent
  - Dependency Agent
  - Custom Script Extension
- Availability zones or availability sets support
- Cloud-init custom data support
- System-assigned or user-assigned managed identity
- Automatic patching configuration
- Comprehensive input validation for all variables
- Integration with terraform-namer for consistent naming and tagging
- Complete test suite (39 tests: 13 functional + 26 validation)
- Comprehensive documentation and examples
- GitHub Actions CI/CD pipeline (7-job workflow)
- Security hardening defaults:
  - SSH-only authentication (password disabled)
  - No public IP by default
  - Encrypted disks
  - Managed identity enabled
  - Boot diagnostics enabled

### Security
- Reserved admin usernames blocked (root, admin, administrator, user, guest, test)
- SSH public key validation (RSA format required)
- OS disk encryption support via Disk Encryption Set
- Data disk encryption support
- Secure defaults throughout module

[Unreleased]: https://github.com/hatboyzero/terraform-azurerm-linux-virtual-machine/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/hatboyzero/terraform-azurerm-linux-virtual-machine/releases/tag/v0.0.1
