vms = {
  app1 = {
    name          = "app1"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = false
  },
  app2 = {
    name          = "app2"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = false
  },
  web = {
    name          = "web"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 10
    disk_type     = "network-hdd"
    nat           = true
  },
  db = {
    name          = "db-main"
    cores         = 2
    memory        = 8
    core_fraction = 20
    disk_size     = 20
    disk_type     = "network-ssd"
    nat           = false
  }
}
