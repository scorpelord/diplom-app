variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "service_account_key_file" {
  description = "Path to service account key file"
  type        = string
  default     = "key.json"
}

variable "k8s_sa_id" {
  description = "Kubernetes service account ID (must exist before apply)"
  type        = string
}
