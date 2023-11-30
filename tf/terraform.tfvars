vms = [
  {
    name          = "app1"
    label         = "backend"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = false
  },
  {
    name          = "app2"
    label         = "backend"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = false
  },
  {
    name          = "web"
    label         = "frontend"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = true
  },
  {
    name          = "db-main"
    label         = "db"
    cores         = 2
    memory        = 8
    core_fraction = 20
    disk_size     = 20
    disk_type     = "network-ssd"
    nat           = false
  }
]
