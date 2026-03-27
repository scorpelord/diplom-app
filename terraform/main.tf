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

# VPC СЕТЬ И ПОДСЕТИ

resource "yandex_vpc_network" "diploma" {
  name = "diploma-net"
}

resource "yandex_vpc_subnet" "subnets" {
  count = 3
  name           = "diploma-subnet-${count.index}"
  zone           = element(["ru-central1-a", "ru-central1-b", "ru-central1-d"], count.index)
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = [cidrsubnet("10.0.0.0/16", 8, count.index)]
}

# ГРУППА БЕЗОПАСНОСТИ

resource "yandex_vpc_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Security group for Kubernetes cluster"
  network_id  = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ИСПОЛЬЗУЕМ СУЩЕСТВУЮЩИЙ СЕРВИСНЫЙ АККАУНТ

data "yandex_iam_service_account" "k8s_sa" {
  name = "k8s-sa"
}

# MANAGED KUBERNETES CLUSTER

resource "yandex_kubernetes_cluster" "diploma" {
  name        = "diploma-cluster"
  description = "Diploma Kubernetes cluster"
  network_id  = yandex_vpc_network.diploma.id
  
  master {
    version = "1.31"
    public_ip = true
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
    
    zonal {
      zone      = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnets[0].id
    }
  }
  
  service_account_id      = data.yandex_iam_service_account.k8s_sa.id
  node_service_account_id = data.yandex_iam_service_account.k8s_sa.id
}

# ГРУППА РАБОЧИХ НОД

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
      subnet_ids = [yandex_vpc_subnet.subnets[0].id]
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

# OUTPUTS

output "cluster_id" {
  value = yandex_kubernetes_cluster.diploma.id
}

output "cluster_name" {
  value = yandex_kubernetes_cluster.diploma.name
}
