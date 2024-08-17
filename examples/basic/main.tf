module "check_vm" {
  source = "../.."

  pm_api_url  = var.pm_api_url
  pm_user     = var.pm_user
  pm_password = var.pm_password
  node_name   = var.node_name
  vm_id       = var.vm_id
}