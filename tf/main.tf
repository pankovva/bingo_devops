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
  for_each                  = var.vms
  name                      = each.value["name"]
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  hostname                  = each.value["name"]
  resources {
    cores         = each.value["cores"]
    memory        = each.value["memory"]
    core_fraction = each.value["core_fraction"]
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.main-b.id
    nat       = each.value["nat"]
    dns_record {
      fqdn        = each.value["name"]
      dns_zone_id = yandex_dns_zone.bingo-dns.id
    }
  }
  boot_disk {
    initialize_params {
      image_id = "fd8tkfhqgbht3sigr37c"
      size     = each.value["disk_size"]
      type = each.value["disk_type"]
    }
  }

  scheduling_policy {
    preemptible = true
  }
  metadata = {
    "user-data" = "${file("user.yaml")}"
  }
}
