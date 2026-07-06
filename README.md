# cloud-cost-finops

Tehničko uputstvo za pokretanje i proveru koda iz repozitorijuma.

## Preduslovi

Na računaru treba da budu instalirani:

- Git
- Docker Desktop
- Terraform CLI
- Infracost CLI
- kubectl
- Helm
- Minikube

Provera instalacije:

```powershell
git --version
docker --version
terraform -version
infracost --version
kubectl version --client
helm version
minikube version
```

## Struktura projekta

```text
cloud-cost-finops/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── k8s/
│   ├── namespace.yaml
│   ├── low-resource-app.yaml
│   ├── medium-resource-app.yaml
│   └── high-resource-app.yaml
├── .github/
│   └── workflows/
│       └── infracost.yml
├── .gitignore
└── README.md
```

## Terraform komande

Prelazak u Terraform folder:

```powershell
cd terraform
```

Formatiranje Terraform fajlova:

```powershell
terraform fmt
```

Inicijalizacija Terraform radnog direktorijuma:

```powershell
terraform init
```

Validacija Terraform konfiguracije:

```powershell
terraform validate
```

Lokalna Infracost procena:

```powershell
infracost breakdown --path .
```

Povratak u root folder projekta:

```powershell
cd ..
```

## Infracost podešavanje

Lokalno podešavanje Infracost CLI-ja:

```powershell
infracost setup
```

GitHub Actions koristi repository secret pod nazivom:

```text
INFRACOST_API_KEY
```

Secret se dodaje u GitHub repozitorijumu kroz:

```text
Settings > Secrets and variables > Actions > New repository secret
```

## GitHub Actions workflow

Workflow fajl se nalazi na putanji:

```text
.github/workflows/infracost.yml
```

Workflow se pokreće na Pull Request kada se menjaju:

```text
terraform/**
.github/workflows/infracost.yml
```

Za testiranje Pull Request procene troškova može se napraviti posebna grana:

```powershell
git checkout main
git pull origin main
git checkout -b increase-infrastructure-cost
```

Nakon izmene Terraform fajlova:

```powershell
git add terraform/variables.tf
git commit -m "Increase Terraform infrastructure cost scenario"
git push -u origin increase-infrastructure-cost
```

Zatim se na GitHub-u otvara Pull Request iz grane:

```text
increase-infrastructure-cost
```

ka grani:

```text
main
```

## Pokretanje lokalnog Kubernetes klastera

Provera Docker-a:

```powershell
docker ps
```

Pokretanje Minikube klastera:

```powershell
minikube start --profile finops-cluster --driver=docker --cpus=2 --memory=4096
```

Provera statusa klastera:

```powershell
minikube status --profile finops-cluster
kubectl get nodes
kubectl config current-context
```

Prikaz sistemskih resursa:

```powershell
kubectl get namespaces
kubectl get pods -A
```

## Kubernetes namespace

Primena namespace manifesta:

```powershell
kubectl apply -f k8s/namespace.yaml
```

Provera namespace-a:

```powershell
kubectl get namespace finops-demo
kubectl describe namespace finops-demo
```

## Instalacija OpenCost-a

Dodavanje OpenCost Helm repozitorijuma:

```powershell
helm repo add opencost https://opencost.github.io/opencost-helm-chart
helm repo update
```

Kreiranje OpenCost namespace-a:

```powershell
kubectl create namespace opencost
```

Instalacija OpenCost-a:

```powershell
helm install opencost opencost/opencost --namespace opencost
```

Provera instalacije:

```powershell
helm list -n opencost
kubectl get pods -n opencost
kubectl get svc -n opencost
```

Port-forward za OpenCost dashboard:

```powershell
kubectl --namespace opencost port-forward service/opencost 9090:9090
```

Dashboard se otvara u browseru na adresi:

```text
http://localhost:9090
```

## Pokretanje test workload-a

Primena Kubernetes manifest fajlova:

```powershell
kubectl apply -f k8s/low-resource-app.yaml
kubectl apply -f k8s/medium-resource-app.yaml
kubectl apply -f k8s/high-resource-app.yaml
```

Provera deployment-a:

```powershell
kubectl get deployments -n finops-demo
```

Provera podova:

```powershell
kubectl get pods -n finops-demo -o wide
```

Prikaz detalja deployment-a:

```powershell
kubectl describe deployment low-resource-app -n finops-demo
kubectl describe deployment medium-resource-app -n finops-demo
kubectl describe deployment high-resource-app -n finops-demo
```

## Metrics Server i potrošnja resursa

Uključivanje Metrics Server dodatka:

```powershell
minikube addons enable metrics-server --profile finops-cluster
```

Provera metrics-server poda:

```powershell
kubectl get pods -n kube-system | findstr metrics
```

Prikaz trenutne potrošnje podova:

```powershell
kubectl top pods -n finops-demo
```

Prikaz alociranih resursa na node-u:

```powershell
kubectl describe node
```

U izlazu se koristi deo:

```text
Non-terminated Pods
Allocated resources
```

## Git komande

Provera statusa:

```powershell
git status
```

Dodavanje izmena:

```powershell
git add .
```

Commit:

```powershell
git commit -m "Update project files"
```

Push:

```powershell
git push
```

## Zaustavljanje lokalnog okruženja

Zaustavljanje port-forward procesa:

```text
Ctrl + C
```

Zaustavljanje Minikube klastera:

```powershell
minikube stop --profile finops-cluster
```

Ponovno pokretanje klastera:

```powershell
minikube start --profile finops-cluster --driver=docker --cpus=2 --memory=4096
```

Brisanje lokalnog klastera:

```powershell
minikube delete --profile finops-cluster
```

## Čišćenje Kubernetes resursa

Brisanje test workload-a:

```powershell
kubectl delete -f k8s/low-resource-app.yaml
kubectl delete -f k8s/medium-resource-app.yaml
kubectl delete -f k8s/high-resource-app.yaml
```

Brisanje test namespace-a:

```powershell
kubectl delete namespace finops-demo
```

Brisanje OpenCost instalacije:

```powershell
helm uninstall opencost -n opencost
kubectl delete namespace opencost
```
