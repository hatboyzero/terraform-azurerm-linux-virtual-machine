# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
