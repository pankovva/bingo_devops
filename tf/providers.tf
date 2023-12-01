terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.99.1"
    }
  }
}

provider "yandex" {
  service_account_key_file = file(var.yc_key)
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_zone
}