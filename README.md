# Terraform Proxmox VM Check Module

This Terraform module checks for the existence of a VM in Proxmox Virtual Environment. It uses the Proxmox API to query the status of a specified VM and returns a boolean indicating whether the VM exists.

## Features

- Checks for the existence of a specific VM in Proxmox
- Uses secure HTTPS connections to the Proxmox API
- Implements best practices for handling sensitive data
- Includes OPA (Open Policy Agent) tests for validation

## Usage

To use this module in your Terraform configuration, add the following:

```hcl
module "proxmox_vm_check" {
  source  = "janpreet/vm-check/proxmox"
  version = "1.0.0"

  pm_api_url  = "https://proxmox.example.com:8006/api2/json"
  pm_user     = "root@pam"
  pm_password = var.proxmox_password
  node_name   = "pve"
  vm_id       = 100

  vm_exists_file_path  = "${path.root}/vm_exists.txt"
}
```

Make sure to use the latest version number available in the Terraform Registry.

## Requirements

- Terraform 0.13+
- Proxmox Virtual Environment 6.x+
- `curl` and `jq` installed on the machine running Terraform

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pm_api_url | Proxmox API URL (must use HTTPS) | `string` | n/a | yes |
| pm_user | Proxmox user | `string` | n/a | yes |
| pm_password | Proxmox password (marked as sensitive) | `string` | n/a | yes |
| node_name | Proxmox node name | `string` | n/a | yes |
| vm_id | VM ID to check (must be a positive integer) | `number` | n/a | yes |
| vm_exists_file_path | Path to the file where VM existence result is stored | `string`	| ${path.root}/vm_exists.txt | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_exists | Boolean indicating whether the VM exists |

## Example

```hcl
module "check_vm" {
  source  = "janpreet/vm-check/proxmox"
  version = "1.0.0"

  pm_api_url  = "https://proxmox.example.com:8006/api2/json"
  pm_user     = "root@pam"
  pm_password = var.proxmox_password
  node_name   = "pve"
  vm_id       = 100

  vm_exists_file_path  = "${path.root}/vm_exists.txt"
}

output "vm_100_exists" {
  value = module.check_vm.vm_exists
}
```

## Security Considerations

- Always use HTTPS for the Proxmox API URL.
- The `pm_password` variable is marked as sensitive. Ensure you're not logging or exposing this value.
- It's recommended to use a Terraform backend that supports encryption at rest for your state files, as they may contain sensitive information.
- Consider using Vault or another secrets management solution to securely provide the Proxmox password at runtime.

## Local Development and Testing

For local development and testing, you can use environment variables to provide sensitive information:

```sh
export TF_VAR_pm_password="your-proxmox-password"
terraform plan
```

This approach keeps sensitive data out of your Terraform files and version control.

## Continuous Integration and Publishing

This module uses GitHub Actions for continuous integration and automated publishing to the Terraform Registry. The workflow performs the following:

- Terraform format and validation
- Static analysis with TFLint
- OPA policy checks
- Security and compliance scanning with Checkov and Terrascan
- Vulnerability scanning with Trivy
- Automatic README updates with terraform-docs
- Publishing to the Terraform Registry on new releases

Note: The CI process does not perform actual Proxmox API calls or require Proxmox credentials, ensuring that sensitive information is not needed in the GitHub repository or Actions.

## Versioning

This module follows semantic versioning. When using the module, it's recommended to pin to a specific version:

```hcl
module "proxmox_vm_check" {
  source  = "janpreet/vm-check/proxmox"
  version = "1.0.0"
  # ... other configuration ...
}
```

Check the [Terraform Registry](https://registry.terraform.io/modules/janpreet/vm-check/proxmox/latest) for the latest available version.

## Contributing

Contributions to this module are welcome. Please ensure that any PRs include appropriate tests and documentation updates. When testing locally, remember to handle sensitive information securely as described in the "Local Development and Testing" section.

## License

This module is licensed under the MIT License. See the LICENSE file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0.0 |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | Proxmox node name | `string` | n/a | yes |
| <a name="input_pm_api_url"></a> [pm\_api\_url](#input\_pm\_api\_url) | Proxmox API URL | `string` | n/a | yes |
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | Proxmox password | `string` | n/a | yes |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | Proxmox user | `string` | n/a | yes |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | VM ID to check | `number` | n/a | yes |
| <a name="input_vm_exists_file_path"></a> [vm\_exists\_file\_path](#input\_vm\_exists\_file\_path) | Path to the file where VM existence result is stored | `string` | `"vm_exists.txt"` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_exists"></a> [vm\_exists](#output\_vm\_exists) | Boolean indicating whether the VM exists |
<!-- END_TF_DOCS -->
