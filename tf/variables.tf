# yandex provider
variable "yc_cloud_id" {}
variable "yc_folder_id" {}
variable "yc_zone" { default = "ru-central1-b" }
variable "yc_key" {}

variable "ssh_user" { default = "ansible" }

variable "vms" {
  type = list(object({
    name          = string
    label         = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
    nat           = bool
  }))
}