#YC 

yc_cloud_id  = "b1g4gcgl5dde0l9228ob"
yc_folder_id = "b1g1g26ib1lrmcck2t14"
yc_key       = "tf-mgr_key.json"

#

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


local_comands = [
  "./venv/bin/ansible-playbook pb_install_postgres.yml",
  "./venv/bin/ansible-playbook pb_install_app.yml",
  "./venv/bin/ansible-playbook pb_install_web.yml",

]