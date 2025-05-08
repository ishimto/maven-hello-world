# GitHub Actions - Maven CI/CD


## Overview
Regardless of the software product that you will make, probably you often integration your local and remote repository code, run tests, and in the end you probably going to deploy/deliver your product, etc.. that process play a big part of a Devops Life-Cycle.
In that project you will understand deeply (hopefully) the CI/CD part's that might could help you in your own SDLC - Software Development Life-Cycle.


## Key Topics
The following topics will be coverd in thats project:
* Git Branching Strategy
* GitHub Actions
* Sementic Versioning
* Maven
* Docker Compose
* Docker Context
* K8s + Helm

### Folder Tree Reference:
```
.
├── compose.yaml
├── Dockerfile
├── helm
│   ├── Chart.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── namespace.yaml
│   │   ├── NOTES.txt
│   │   ├── secrets.yaml
│   │   └── service.yaml
│   └── values.yaml
├── ingress-nginx
│   ├── README.md
│   └── terraform
│       ├── main.tf
│       └── provider.tf
├── myapp
│   ├── pom.xml
│   └── src
│       ├── main
│       │   └── java
│       │       └── com
│       │           └── myapp
│       │               └── App.java
│       └── test
│           └── java
│               └── com
│                   └── myapp
│                       └── AppTest.java
└── sidecar
    ├── Dockerfile
    ├── hello.py
    └── requirements.txt
```
