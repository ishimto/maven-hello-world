---
Ingress NGINX

---

# folder tree:
```
.
├── README.md
└── terraform
    ├── main.tf
    └── provider.tf
    ```

# Minikube
* install:
minikube addons enable ingress



# Helm Release for the cloud

* Install:
./terraform

- initialize terraform:
terraform init 

- plan:
plan your steps:
terraform plan

- create nginx ingress controller:
terraform apply
