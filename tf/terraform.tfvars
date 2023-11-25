vms = {
  app1 = {
    name          = "app1"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 20
    nat           = false
  },
  app2 = {
    name          = "app2"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 20
    nat           = false
  },
  web = {
    name          = "web"
    cores         = 2
    memory        = 2
    core_fraction = 20
    disk_size     = 20
    nat           = true
  }
}
