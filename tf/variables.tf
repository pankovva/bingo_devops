# yandex provider
variable "yc_cloud_id" {}
variable "yc_folder_id" {}
variable "yc_zone" { default = "ru-central1-b" }
variable "yc_key" {}

variable "vms" {
  type = map(object({
    name          = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    nat           = bool
  }))
}