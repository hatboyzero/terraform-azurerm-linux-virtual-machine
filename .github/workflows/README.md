# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the terraform-terraform-namer module.

## Workflows

### 1. Test Workflow (`test.yml`)

**Purpose**: Comprehensive testing and validation for pull requests and pushes to main branches.

**Triggers**:
- Pull requests to `main` or `develop` branches
- Pushes to `main` or `develop` branches
- Changes to `*.tf` files, `test/**`, or the workflow file itself
- Manual workflow dispatch

**Jobs**:

#### terraform-format
- **Purpose**: Ensures all Terraform files are properly formatted
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Setup Terraform v1.13.4
  3. Run `terraform fmt -check -recursive`
- **Outcome**: Fails if any files are not formatted

#### terraform-validate
- **Purpose**: Validates Terraform configuration syntax
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Setup Terraform v1.13.4
  3. Initialize Terraform (backend disabled)
  4. Run `terraform validate`
- **Outcome**: Fails if configuration is invalid

#### go-tests
- **Purpose**: Runs Go-based Terratest tests across multiple Terraform versions
- **Runs on**: Ubuntu Latest
- **Matrix Strategy**: Tests against Terraform versions 1.13.4, 1.9.0, and latest
- **Steps**:
  1. Checkout code
  2. Setup Go v1.18
  3. Setup Terraform (matrix version)
  4. Download Go dependencies
  5. Run tests with 30m timeout
  6. Upload test results as artifacts
- **Environment**: `TF_ACC=1` for acceptance tests
- **Outcome**: Produces test results for each Terraform version

#### terraform-docs
- **Purpose**: Verifies documentation is up to date
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Run terraform-docs to regenerate documentation
  3. Check for differences (fail-on-diff)
- **Outcome**: Fails if documentation is out of sync

#### security-scan
- **Purpose**: Scans for security vulnerabilities using Checkov
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Run Checkov security scanner
  3. Generate SARIF report
  4. Upload SARIF to GitHub Security tab
- **Configuration**: Soft fail enabled, skips git history check
- **Outcome**: Reports security findings without blocking

#### lint
- **Purpose**: Analyzes code quality using TFLint
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Setup TFLint (latest version)
  3. Initialize TFLint
  4. Run TFLint with compact output
- **Outcome**: Fails if linting issues are found

#### test-examples
- **Purpose**: Validates all example configurations
- **Runs on**: Ubuntu Latest
- **Matrix Strategy**: Tests each example (default, demo, nullvars, with-resource-type)
- **Steps**:
  1. Checkout code
  2. Setup Terraform v1.13.4
  3. Initialize example
  4. Validate example
  5. Create plan
  6. Upload plan as artifact
- **Outcome**: Ensures all examples are valid

#### test-summary
- **Purpose**: Aggregates results from all test jobs
- **Runs on**: Ubuntu Latest
- **Dependencies**: Waits for all other jobs
- **Condition**: Always runs (even if previous jobs fail)
- **Steps**:
  1. Generate summary table of all job results
  2. Fail if any required job failed
- **Outcome**: Single source of truth for test status

#### comment-pr
- **Purpose**: Posts test results as PR comment
- **Runs on**: Ubuntu Latest
- **Dependencies**: Waits for test-summary
- **Condition**: Only runs on pull requests
- **Permissions**: Requires `pull-requests: write`
- **Steps**:
  1. Generate formatted summary with emoji indicators
  2. Post comment to PR
- **Outcome**: Provides visible test status in PR conversation

### 2. Release Workflow (`release-module.yml`)

**Purpose**: Automates creation of GitHub releases for version tags.

**Triggers**:
- Push of tags matching pattern `0.0.*`

**Jobs**:

#### release
- **Purpose**: Creates GitHub release with auto-generated notes
- **Runs on**: Ubuntu Latest
- **Steps**:
  1. Checkout code
  2. Create release using tag name
  3. Generate release notes from commits
- **Permissions**: Requires `contents: write`
- **Outcome**: Creates new GitHub release

## Workflow Permissions

### Read Permissions
- `contents: read` - For checking out code

### Write Permissions
- `pull-requests: write` - For commenting on PRs (test.yml)
- `contents: write` - For creating releases (release-module.yml)

## Status Badges

You can add status badges to your README.md:

```markdown
![Terraform Tests](https://github.com/kelomai/terraform-terraform-namer/actions/workflows/test.yml/badge.svg)
```

## Local Testing

Before pushing code, you can run similar checks locally:

```bash
# Format check
terraform fmt -check -recursive

# Validation
terraform init -backend=false
terraform validate

# Run tests
cd test && go test -v -timeout 30m

# Generate docs
terraform-docs markdown document --output-file README.md --output-mode inject .

# Security scan (requires tfsec)
tfsec .

# Linting (requires tflint)
tflint --init && tflint
```

Or use the Makefile:

```bash
make pre-commit  # Runs format, validate, and test
make dev         # Complete development workflow
```

## Customization

### Adding New Test Jobs

To add a new test job to `test.yml`:

1. Add a new job under the `jobs:` section
2. Define the job steps
3. Add the job to the `needs:` array in `test-summary`
4. Update the summary generation in `test-summary` steps
5. Update the PR comment template in `comment-pr`

Example:

```yaml
my-new-check:
  name: My New Check
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Run my check
      run: ./my-check-script.sh
```

### Changing Terraform Versions

To test against different Terraform versions, modify the matrix in the `go-tests` job:

```yaml
strategy:
  matrix:
    terraform-version: ["1.13.4", "1.5.0", "latest"]
```

### Modifying Triggers

To change when workflows run, modify the `on:` section:

```yaml
on:
  push:
    branches: [main, develop, staging]
  pull_request:
    branches: [main]
```

## Troubleshooting

### Tests Failing in CI but Passing Locally

1. Check Terraform version differences
2. Verify Go version matches CI (1.18)
3. Ensure all files are committed
4. Check for environment-specific issues

### Documentation Check Failing

Run `make docs` locally and commit the changes:

```bash
make docs
git add README.md
git commit -m "docs: Update auto-generated documentation"
```

### Security Scan Findings

Review the findings in the GitHub Security tab under "Code scanning alerts". Address critical and high severity issues.

### TFLint Errors

Run TFLint locally to see detailed error messages:

```bash
tflint --init
tflint --format compact
```

## Best Practices

1. **Always run local checks** before pushing: `make pre-commit`
2. **Keep workflows DRY** - Use reusable workflows for common tasks
3. **Use caching** - Cache dependencies to speed up workflows
4. **Minimize workflow runs** - Use path filters to avoid unnecessary runs
5. **Monitor workflow costs** - Track Actions usage in repository settings
6. **Keep secrets secure** - Never log sensitive information
7. **Use specific action versions** - Pin to specific versions (e.g., `@v4`, not `@main`)

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [Checkov Documentation](https://www.checkov.io/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [terraform-docs](https://terraform-docs.io/)

---

For questions or issues with the CI/CD workflows, please open an issue in the repository.
