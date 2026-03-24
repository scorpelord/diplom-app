terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
}

# ============================================
# VPC СЕТЬ И ПОДСЕТИ
# ============================================

data "yandex_vpc_network" "diploma" {
  name = "diploma-net"
}

data "yandex_vpc_subnet" "subnet_a" {
  name = "diploma-subnet-0"
}

data "yandex_vpc_subnet" "subnet_b" {
  name = "diploma-subnet-1"
}

data "yandex_vpc_subnet" "subnet_d" {
  name = "diploma-subnet-2"
}

# ============================================
# СУЩЕСТВУЮЩИЙ КЛАСТЕР K8S
# ============================================

resource "yandex_kubernetes_cluster" "diploma" {
  name        = "diploma-cluster"
  description = "Diploma Kubernetes cluster"
  network_id  = data.yandex_vpc_network.diploma.id
  
  master {
    version = "1.31"
    public_ip = true
    zonal {
      zone      = "ru-central1-a"
      subnet_id = data.yandex_vpc_subnet.subnet_a.id
    }
  }
  
  service_account_id      = var.k8s_sa_id
  node_service_account_id = var.k8s_sa_id
}

# ============================================
# ГРУППА РАБОЧИХ НОД
# ============================================

resource "yandex_kubernetes_node_group" "worker_nodes" {
  cluster_id = yandex_kubernetes_cluster.diploma.id
  name       = "worker-nodes"
  
  instance_template {
    platform_id = "standard-v2"
    
    resources {
      cores  = 2
      memory = 4
    }
    
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    
    network_interface {
      subnet_ids = [data.yandex_vpc_subnet.subnet_a.id]
      nat        = true
    }
    
    scheduling_policy {
      preemptible = true
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.diploma.id
}

output "cluster_name" {
  value = yandex_kubernetes_cluster.diploma.name
}
