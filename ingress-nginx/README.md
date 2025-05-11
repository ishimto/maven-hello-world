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

```
minikube addons enable ingress
```

run and save the output:

```
minikube ip
```

go to /etc/hosts and map the above output with your host like that:

```
IP HOST
```

that's way the dns resolver know where to go (to the ingress) when you try reach sidecar via ingress. 

# Helm Release for the cloud

* Install:
./terraform

Copy thats code to your main eks terraform, and make them depend each other, the ingress-nginx should be depend on the VPC, thats way when you will destroy the eks, it will destroy also the load balancer resource, otherwise, your eks destroy will get in loop when you try to destroy it, and you'll need connect to the console and remove it manually.



## DNS Record for host-based ingress

2 options:
### Route53
go to route53, register domain and create public hosted zone (if you create private, you'll need vpn access for it).
when you create public hosted zone, create A record with alias into your classic load balancer that the nginx controller created when you run terraform apply before, that's importent because the IP of loadbalancer might changed, that's way it's not depend on the ip and it will updated automaticlly without needed to maintain it.


### Without Route53
copy the loadbalancer ip
go to /etc/hosts and map the above output with your host like that:

```
IP HOST
```

(you'll need to maintain it because it replaced automaticlly sometimes)
