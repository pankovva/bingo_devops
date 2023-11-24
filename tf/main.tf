# data "yandex_vpc_subnet" "network" {
#   name = "vpc-bingo-ru-central1-b"
# }


resource "yandex_vpc_network" "net-bingo" {
  name = "net-bingo"
}

resource "yandex_vpc_subnet" "main-b" {
  name           = "main-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net-bingo.id
  v4_cidr_blocks = ["192.168.68.0/24"]
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

resource "yandex_compute_disk" "ssd" {
  name       = "data"
  type       = "network-ssd"
  zone       = "ru-central1-b"
  size       = 20
}

resource "yandex_compute_instance" "instance" {
  name                      = "db-main"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  hostname                  = "db-main"
  resources {
    cores         = 2
    memory        = 8
    core_fraction = 20
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.main-b.id
    nat       = true
    dns_record {
      fqdn        = "db-main"
      dns_zone_id = yandex_dns_zone.bingo-dns.id
    }
  }
  boot_disk {
    initialize_params {
      image_id = "fd8tkfhqgbht3sigr37c"
      size     = 20
      # type     = "network-ssd"
    }
  }
  secondary_disk {
    disk_id     = yandex_compute_disk.ssd.id
    auto_delete = true
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    "user-data" = "${file("user.yaml")}"
  }
}

