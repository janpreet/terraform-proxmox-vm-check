package terraform.proxmox_vm_check

import future.keywords.in

deny[msg] {
    resource := input.planned_values.root_module.resources[_]
    resource.type == "null_resource"
    not resource.values.triggers.always_run
    msg := "null_resource should have an always_run trigger"
}

deny[msg] {
    variable := input.variables[_]
    required_vars := {"pm_api_url", "pm_user", "pm_password", "node_name", "vm_id"}
    variable.name in required_vars
    not variable.value
    msg := sprintf("Required variable %v is not set", [variable.name])
}

deny[msg] {
    output := input.planned_values.outputs.vm_exists
    not output
    msg := "Output 'vm_exists' is not defined"
}

deny[msg] {
    not input.variables.pm_password.sensitive
    msg := "Variable 'pm_password' should be marked as sensitive"
}

deny[msg] {
    not startswith(input.variables.pm_api_url.value, "https://")
    msg := "Proxmox API URL should use HTTPS"
}

deny[msg] {
    vm_id := to_number(input.variables.vm_id.value)
    vm_id <= 0
    msg := "VM ID should be a positive integer"
}

deny[msg] {
    resource := input.planned_values.root_module.resources[_]
    resource.type == "null_resource"
    provisioner := resource.values.provisioner[_]
    provisioner.type == "local-exec"
    contains(provisioner.command, input.variables.pm_password.value)
    msg := "local-exec provisioner should use environment variables for sensitive data"
}

deny[msg] {
    provider := input.configuration.provider_config[_]
    provider.name == "null"
    not provider.version_constraint
    msg := "Module should specify a version constraint for the null provider"
}

deny[msg] {
    provider := input.configuration.provider_config[_]
    provider.name == "local"
    not provider.version_constraint
    msg := "Module should specify a version constraint for the local provider"
}