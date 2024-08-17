resource "null_resource" "check_vm" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      result=$(curl -s -k -d "username=${var.pm_user}&password=${var.pm_password}" ${var.pm_api_url}/access/ticket | jq -r '.data.ticket' | xargs -I {} curl -s -k -H "Authorization: PVEAuthCookie={}" ${var.pm_api_url}/nodes/${var.node_name}/qemu/${var.vm_id}/status/current | jq -r '.data.status')
      if [ "$result" != "null" ]; then
        echo "true" > ${var.vm_exists_file_path}
      else
        echo "false" > ${var.vm_exists_file_path}
      fi
    EOT
  }
}

data "local_file" "vm_exists" {
  depends_on = [null_resource.check_vm]
  filename   = var.vm_exists_file_path
}

output "vm_exists" {
  value = data.local_file.vm_exists.content == "true"
}
