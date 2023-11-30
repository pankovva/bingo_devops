resource "yandex_vpc_network" "net-bingo" {
  name = "net-bingo"
}

resource "yandex_vpc_gateway" "egress-gateway" {
  name = "gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt-b" {
  name       = "main"
  network_id = yandex_vpc_network.net-bingo.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }
}

resource "yandex_vpc_subnet" "main-b" {
  name           = "main-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net-bingo.id
  v4_cidr_blocks = ["192.168.68.0/24"]
  route_table_id = yandex_vpc_route_table.rt-b.id
  dhcp_options {
    domain_name = "bingo.local"
  }
}


resource "yandex_dns_zone" "bingo-dns" {
  name        = "bingo-dns"
  description = "bingo prod dns zone"


  zone             = "bingo.local."
  public           = false
  private_networks = [yandex_vpc_network.net-bingo.id]
}


resource "yandex_compute_instance" "vm" {
  count                     = length(var.vms)
  name                      = var.vms[count.index]["name"]
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  hostname                  = var.vms[count.index]["name"]
  labels = {
    group = var.vms[count.index]["label"]
  }
  resources {
    cores         = var.vms[count.index]["cores"]
    memory        = var.vms[count.index]["memory"]
    core_fraction = var.vms[count.index]["core_fraction"]
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.main-b.id
    nat       = var.vms[count.index]["nat"]
    dns_record {
      fqdn        = var.vms[count.index]["name"]
      dns_zone_id = yandex_dns_zone.bingo-dns.id
    }
  }
  boot_disk {
    initialize_params {
      image_id = "fd8tkfhqgbht3sigr37c"
      size     = var.vms[count.index]["disk_size"]
      type     = var.vms[count.index]["disk_type"]
    }
  }

  scheduling_policy {
    preemptible = true
  }
  metadata = {
    "user-data" = <<-EOT
      #cloud-config
      users:
        - name: ${var.ssh_user}
          sudo: "ALL=(ALL) NOPASSWD:ALL"
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file("ansible_ssh_key.pub")}
      EOT
  }
}


resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tftpl",
    {
      vms      = yandex_compute_instance.vm,
      ssh_user = var.ssh_user
  })
  filename        = "../ansible/inventory"
  file_permission = "0644"
}
