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


## Git Branching Strategy
The common git branching strategies are Git Flow, Github Flow, Trunk, Gitlab Flow, each one has his own pros and cons.
Github Flow and Trunk used for small-med teams, using 2 branches in the formal version, these methods used for fast development out of main branch and merge/commit directly.
Git Flow and Gitlab Flow used for med-large teams using 4-5 branches, with propuse for each branch like hotfix in prod, test new features etc..
In this project the chosen branching strategy was costum branching strategy some where between the above branche's mentioned, using 3 branches, some places calls it "Three Branch Strategy", and in other versions of trunk there is more branch and it can play like this practice, but it's not have a formal name.

### Branches in our project:
* master - protected branch, what means push accepted just with Pull Request, after review. that branch used to hold production stable version.
* stage - used to test the code in environment that's look like the production, but it's not, and check if the version stable to be in the prod.
* features - same as stage, run tests and check the version and when it work's on features, we merge it into stage.

but wait. if stage and features do the same what the purpose of it??
in features we push to the registry each build with commit hash, but not change the version that way we can follow versions and also to test (Part of the CI) before we merge into stage environment.

if stage environment we update in the end the version in pom.xml (we'll talk about it later), and patch version (we'll talk about sementic version later), in the end if it pass the all stages, and when we PR into master, it deploy that version.



