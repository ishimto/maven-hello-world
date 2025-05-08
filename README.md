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

in the stage environment we update in the end the version in pom.xml (we'll talk about it later), and increment the patch version (we'll talk about sementic version later), in the end if it pass the all stages, and when we PR into master, it deploy that version.



## Github Actions
There are a lot of tools for CI/CD like jenkins, gitlab-ci etc.. each one has it's own benefits.
in our project we use the most prefared tool to integrate with github --> Github Actions, but why?

### Keywords
* Workflow
* Triggers
* Jobs
* Steps
* Actions

### Overview
Github Actions CI/CD file calls Workflow, in compare to jenkins --> Jenkinsfile.
in the workflow you define few things:
* triggers - to start the CI/CD process like push,pr and more, it's very flexible.
* jobs - each job run on new runner, in the end of the job Github will clean the runner and you will get a new one next time.
* steps - this is the actually CI/CD process, thats how you define the "steps" of it and what will happen.
* Actions - Github Actions has a lot of.. well.. actions. but wait, what is it?
Actions are individual tasks that you can combine to customize the workflow, you can create your own or use others by shared actions by github community.
the action saved in repository as action.yaml the first part of action name is the organization name and the second is the repo name, then the tag.
i.e: actions/checkout@v4, you can find it in "actions" organization in checkout repo with version tag 4.
this actions simplifies the CI/CD process, i.e, instead of doing git clone ... you can use actions/checkout@v4 to checkout your code in short block,
and there are a lot of actions that can be usefully. in compare to jenkins --> Plugins.


