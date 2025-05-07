---
Ingress NGINX

If you decided to expose your application out of cluster in efficency use this guide
---

# folder tree:
├── helm-templates
│   ├── ingress.yaml
│   ├── services.yaml
│   └── values.yaml
└── terraform
    ├── main.tf
    └── provider.tf


* Install:
./terraform

- initialize terraform:
terraform init 

- plan:
plan your steps:
terraform plan

- create nginx ingress controller:
terraform apply




* Confige:
./helm-templates
move ingress.yaml && services.yaml into ../../helm/templates/ (your app release)

values.yaml:
modify ingress.app.host to your DNS (i.e Your Route53 DNS)
- Config DNS Record: get in Route53 and create DNS A Record Alias to LoadBalancer using Public/Private hosted zone depend on demand.
  importent!! Alias will watch the loadbalancer and will manage the update of the IP in record in cases it changed.
copy the values.yaml into values.yaml of ../../helm/values.yaml (values of app release)


get in app helm dir (../../helm):
helm upgrade [RELEASE_NAME] .


Congrats!!
You have now ingress controller to your application using Host-Based routing
