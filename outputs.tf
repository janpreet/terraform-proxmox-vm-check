output "vm_exists" {
  description = "Boolean indicating whether the VM exists"
  value       = trimspace(data.local_file.vm_exists.content) == "true"
}