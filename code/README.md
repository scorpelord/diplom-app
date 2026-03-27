## ПОДГОТОВКА ОКРУЖЕНИЯ (VS Code / Ubuntu)

```
terraform version
docker --version
kubectl version --client
helm version
yc version
```

## РАБОТА С РЕПОЗИТОРИЕМ (Git)

```
git clone https://github.com/scorpelord/diplom-app.git
cd diplom-app
git status
git add index.html Dockerfile
git commit -m "Add test app"
git push origin main
```

## YANDEX CLOUD CLI (авторизация, сервисный аккаунт)

```
yc init
yc iam service-account create --name diploma-sa
yc iam service-account list
yc iam key create --service-account-name diploma-sa --output key.json
yc config set service-account-key key.json
yc config list
```

## CONTAINER REGISTRY

```
yc container registry create --name diploma-registry
yc container registry list
yc container registry configure-docker
```

## DOCKER (сборка и push образа)

```
cd ~/diplom/diplom-app
docker build -t cr.yandex/crpajqvnc6vh3duplq4s/diplom-app:latest .
docker push cr.yandex/crpajqvnc6vh3duplq4s/diplom-app:latest
yc container image list --registry-id crpajqvnc6vh3duplq4s
```

## TERRAFORM (инициализация, план, применение)

```
cd ~/diplom/terraform
terraform init
terraform plan
terraform apply -auto-approve
```

## РУЧНОЕ НАЗНАЧЕНИЕ РОЛЕЙ СЕРВИСНОМУ АККАУНТУ

**Роли были выданы через Yandex Console**

## ПОДКЛЮЧЕНИЕ К KUBERNETES

```
yc managed-kubernetes cluster get-credentials diploma-cluster --external
kubectl cluster-info
kubectl get nodes
kubectl get pods --all-namespaces
```

## HELM + МОНИТОРИНГ (kube-prometheus-stack)

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.service.type=LoadBalancer \
  --set grafana.service.port=80 \
  --set grafana.adminPassword=admin123
```

## ДЕПЛОЙ ПРИЛОЖЕНИЯ В KUBERNETES

```
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get pods
kubectl get svc
```

## ПРОВЕРКА ДОСТУПА

```
curl http://158.160.227.146
kubectl get svc -n monitoring kube-prometheus-stack-grafana
```

## CI/CD (GITHUB ACTIONS)

```
# файл .github/workflows/ci-cd.yml
git push origin main
git tag v1.0.0
git push origin v1.0.0
```

## ОСТАНОВКА И УДАЛЕНИЕ РЕСУРСОВ (для экономии)

```
cd ~/diplom/terraform
terraform destroy -auto-approve
```
