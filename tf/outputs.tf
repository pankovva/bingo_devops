output "vm_public_ip" {
  #value = yandex_compute_instance.vm[each.key].network_interface.0.nat_ip_address

  value = { for vm, vl in yandex_compute_instance.vm : vm => vl.network_interface.0.nat_ip_address }
}