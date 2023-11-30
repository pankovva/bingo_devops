output "frontend_ip" {
  value = {
    for vm in yandex_compute_instance.vm :
    vm.name => vm.network_interface.0.nat_ip_address
    if vm.network_interface.0.nat_ip_address != ""
  }
}

output "created_vm" {
  value = {
    for vm in yandex_compute_instance.vm :
    "${vm.name}.bingo.local" => vm.labels.group
  }
}