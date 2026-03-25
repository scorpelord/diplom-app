# Дипломный практикум в Yandex.Cloud

# Создание облачной инфраструктуры
Созданы: VPC сеть diploma-net, подсети в трёх зонах доступности (ru-central1-a, ru-central1-b, ru-central1-d), группа безопасности k8s-sg, сервисный аккаунт k8s-sa с необходимыми ролями, кластер Managed Kubernetes diploma-cluster, группа worker-нод worker-nodes (2 прерываемые ВМ с 2 vCPU и 4 ГБ RAM). State-файл Terraform хранится локально (планируется перенос в S3 bucket).

<img width="659" height="712" alt="image" src="https://github.com/user-attachments/assets/6801721c-af78-4f43-843c-ec13aba2489e" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/1781d4d7-9dba-4716-a5b5-7957f24a6e6a" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/fe1a413a-d93e-4307-8ed1-a336f6d444e5" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/1ea6d6a1-5dd5-443f-810a-7b2e5ec71578" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/2ba65213-09d9-4c61-a785-d08c9699a4ad" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/7dd842bc-5e1a-46b2-aa9b-b1e27cb70f40" />

<img width="659" height="753" alt="image" src="https://github.com/user-attachments/assets/77694939-1cc3-4144-8b89-8c3b51f87d18" />

# Создание Kubernetes кластера
Кластер diploma-cluster (версия 1.31) содержит 2 worker-ноды в статусе Ready. Ноды являются прерываемыми (preemptible) для экономии ресурсов, развёрнуты в зоне ru-central1-a.
<img width="659" height="79" alt="image" src="https://github.com/user-attachments/assets/f7340975-93aa-44b3-91e9-2b8dfd19b3e8" />
