# GitHub Actions - Maven CI/CD


## Overview
Regardless of the software product that you will make, probably you often integration your local and remote repository code, run tests, and in the end you probably going to deploy/deliver your product, etc.. that process play a big part of a Devops Life-Cycle.
In that project you will understand deeply (hopefully) the CI/CD part's that might could help you in your own SDLC - Software Development Life-Cycle.




## Key Topics
The following topics will be coverd in thats project:
* Project Requirements
* Git Branching Strategy
* GitHub Actions
* Sementic Versioning
* Maven
* Docker
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


## Project Requirements

### Cloud:
in order to use this project, you'll need to create EC2's in AWS and config it with:
1. docker
2. docker compose

create user with permissions to docker and docker compose, and save his credentials for later, secrets.

### Github Repository:
in order to use this project you'll need to create repo and fork this proejct, with 3 branches.
1. master - protected branch.
2. stage
3. test

using the branching strategy i will mention below.


### Docker Repository:
create repository in your docker registry, and make it private.


### Github Repository Secrets:
in order to use this project, you'll need to define the following variables in secrets of github actions with the mentioned name (or edit the workflow):
* DOCKER_REPO - your docker repository name for tagging when you push.
* DOCKER_USERNAME - your docker username.
* DOCKER_TOKEN - create docker token for your account for securely connect, dont use your password, although github saved it securely.
* EC2_PROD_HOST - production ip to let docker context deploy the container.
* EC2_PROD_KEY - production ssh key, for docker context.
* EC2_STAGE_HOST - stage ip for docker context.
* EC2_STAGE_KEY - stage ssh key, for docker context.
* EC2_USER - define with ec2-user, it's the default. if not then create secret for stage and prod, and change it in CI/CD where the HOST is for stage.

### HELM Project:
Will be explained at the end of the readme.


## Git Branching Strategy
The common git branching strategies are Git Flow, Github Flow, Trunk, Gitlab Flow, each one has his own pros and cons.
Github Flow and Trunk used for small-med teams, using 2 branches in the formal version, these methods used for fast development out of main branch and merge/commit directly.
Git Flow and Gitlab Flow used for med-large teams using 4-5 branches, with propuse for each branch like hotfix in prod, test new features etc..
In this project the chosen branching strategy was costum branching strategy some where between the above branche's mentioned, using 3 branches, some places calls it "Three Branch Strategy", and in other versions of trunk there is more branch and it can play like this practice, but it's not have a formal name.

### Dive into the project:
* master - protected branch, what means push accepted just with Pull Request, after review. that branch used to hold production stable version.
* stage - used to test the code in environment that's look like the production, but it's not, and check if the version stable to be in the prod.
* features - same as stage, run tests and check the version and when it work's on features, we merge it into stage.

but wait. if stage and features do the same what the purpose of it??
in features we push to the registry each build with commit hash, but not change the version that way we can follow versions and also to test (Part of the CI) before we merge into stage environment.

in the stage environment we update in the end the version in pom.xml (we'll talk about it later), and increment the patch version (we'll talk about sementic version later), in the end if it pass the all stages, and when we PR into master, it deploy that version.



## Github Actions
There are a lot of tools for CI/CD like jenkins, gitlab-ci etc.. each one has it's own benefits.
in our project we use the most prefared tool to integrate with github --> Github Actions, but why?

### Keywords:
* Workflow
* Triggers
* Jobs
* Steps
* Actions
* Secrets

### Overview:
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


### Dive into the project:
in our workflow, it splitted into 2 jobs:
1st:
job used to run in tests branch, build and check if everything OK with current version, not update the version.
job used to run in stage branch, build and check, and also update the version both in docker repository and in the pom.xml, after everything run succesfully and deployed on stage environment in the end.

2nd:
job used to run when pull requests merged into the master branch, after review and from stage branch what means it deployed succesfully on environment same as the production, it's not build, just deploy, if it failed, it's rollback to the last stable version, if it success, it's update tag the image with stable, now the image have 2 tags, version and stable.


the reason in that's project the workflow splitted into 2 jobs and not one, to make it easy to maintain each environment and don't make mix with a lot of "if" statements.


## Sementic Versioning
Regardless the code you write, it's better to version it so you can know rollback in case it needed or manage few versions if it needed, it also good for docs.
There are a lot of versioning methods, in our project we used sementic version, that build from 3 numbers splitted with ".", like "1.0.0" or "4.2.3" etc..
but WAIT!!!!! i wrote 1.0.0 then 4.2.3, what each number mean?
so.. it's splitted by that method:   Major.Minor.Patch
* Major version incremented when there are breaked changes the existing api.
* Minor version incremented when there are changes but not breaked one, like adding more features.
* Patch version incremented when there are bug fixes and non functionallity changed.


### Dive into the project:
in that CI/CD we incremented just the Patch, and that's what the workflow will do if you merge to stage and it pass the tests succesfully.
if you want to change so it can increment the Major and Minor there is a Action that created by the community (remember? we talked about it before..).
the action name is: nnichols/maven-version-bump-action@v3, it works with commit, searches for #patch #minor #major and increment the chosen one.



## Maven
Build automation tool, and project management tool for java projects.
pom.xml file is the basement of maven, declare data on the project, it should be in the root of the java project, before src/ and test/.
if you create your folder tree like the below tree, maven will know where to look for each thing and you don't need to define anything manually.

```
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
```

### WHY DO WE NEED IT??
as mentioned above, maven is a build automation tool and project management for java project, but what does it mean??
before maven, we needed to:
* manage dependencies - install the JAR (libraries) of third party, save them in folder in out project, and if one library needs other we needed to understand it by ourself, and install the other depend library.
* build - before maven we needed to build scripts to build our project includes the following steps:
  clean, compile, test, package, install and deploy (sometimes also verify and validate as tests).
maven solves it with concept that calls LifeCycles and there are 3 types of lifecycles - default, clean, site.

### pom.xml:
file xml that contains:
* metadata of the project - like version, artifact name (ID) etc..
* dependencies - maven will install it automaticlly, includes them nested dependencies (automation!!!)
* build process with plugins for each phase and them goals that will used includes versions
* repositories - where maven can install dependencies or plugins if needed (extended places and not just the default - maven central)
* distribution - tells maven where to publish the artifact like the JAR file, the credentials for destination saved in settings.xml in m2/.. local repository.
* properties - general variables that can be used over the pom file
etc..


### Plugins && Goals:
plugins are the tools that actually runs the phases in the lifecycle, without them maven not have a real value.
each step in the lifecycle don't really know how to do things, it just "trigger" that run goal from plugin.
so what goal mean?
each plugin has goals, and each goals do specific action in the plugin.
lets take the plugin maven-compiler-plugin, thats the plugin that compiles the source code, you can use it: mvn maven-compiler-plugin:compile

maven has default plugins that it will run when you doing mvn <phase>, if you didn't specify in the pom.xml.
if you want to specify a specific version of plugin or running a specific plugin, you'll need to adding it into pom.xml
the order in pom.xml not say anything, maven still doing it by the order of lifecycle, unless you specify the phase in the plugin execution.


### Life Cycles:
so.. what does it mean lifecycle?
life cycle are steps or "phases" that maven over on them in specific order.

* default:
that life cycle manage the build process, includes 7 phases, when you run phase it will run the all phases before until it and not just it, and i'll explain it with the phases.
1. validate - checks the basic requirements of the project like that there is a valid pom.xml.
2. compile - compile the java source code from src/.. the input is .java output is .class, binary files, into target/ directory.
3. test - run unitests tests from test/..
4. package - package the artifacts from compile into JAR/WAR (Java/Web Archive) into target/ directory
5. verify - run more tests if defined in the pom.xml with plugin (i'll explain it later)
6. install - install the Artifact on local repository, if other projects will need that as dependency they can to use it throw the local repo.
7. deploy - same as local but to remote repo, let collaborate with other developers or in order to manage versioning if needed.
in order to let deploy work, who that try to use it need to define settings.xml and pom.xml the server credentials and permissions.

* clean:
thats lifecycle important if you run maven in the same environment over and over again, you clean the target directory, and let you to compile next time into clean environment.

* site:
that lifecycle responsible of create documents for the porject, create static sites in html format with information about the project.
the data for documents is taken from existing data like result of unitests if there are.
the documents saved in target/site


now after i explained about it, it will be easier to understand what i meant before when i wrote "when you run phase it will run the all phases before until it and not just it" in thge first LifeCycles unit.



### Dive into the project:
that project based on java, therfore we need to compile test etc.. maven automate the build process in our project.
out project using dockerfile to increment the patch using maven plugin, compile and package it and in the and run it in container on production environemt.
you can find the Dockerfile i mentioned, right here:
```
.
├── Dockerfile
```

## Docker
if you read about CI/CD i assume you already know what is it docker so i'll not digging in it too much.
in the project, docker used as a containerization tool for java application.

### Keywords:
* dockerfile
* docker compose
* docker deamon
* docker context


### Overview:
the workflow using docker compose with dockerfile to automate the build of container.

### tree file reference:
```
.
├── compose.yaml
├── Dockerfile
```


project dockerfile using multi-stage to using cache for building, and save just the artifact that needed for the final image in order to decrease her size.
for security, in dockerfile, we used nonroot user, as "at least privileaged".
the build tool in our project is maven, as i mentioned above, maven increment the metadata of version in pom file, compile and build the artifact.
we used docker compose with simple healthcheck to verify in the CI/CD, if the application healthy/unhealthy when it distribute.
the way that implement to distribute the container in CI/CD over environments was docker context.
docker context means "which docker deamon the docker cli speak with" when you running commands with docker, like docker compose up or docker run/build etc...
the docker context in this project use SSH to communicate with the other docker deamon, to implement it we needed to use ssh-agent in order to save the SSH key and let docker context communicate securely.



## HELM Project


### Overview:
Helm project let you deploy one pod (depend on your replicas, you can config it in values if you want to), with two containers in it.
in order to deploy it you need to read the README of ingress-nginx.
that project using ingress controller nginx to give access into the sidecar pod.
you can deploy it on your minikube or on eks cluster, your choose.

* sidecar pod: the sidecar container in that project is a basic python flask, not for production, if you want to deploy it in production use gunicorn or other wsgi that supports flask, make sure you expose the right ports as the service try to access. 
  the role of it is to verify that the application up succesfully.
  you need to config the host value in values.yaml to your prefared host, if you using Route53 there is a little explain in the ingress nginx readme.
  the sidercar container has liveness and readiness engines.
  - k8s liveness verify that the container up succesfully in route "/health", if the container restarts without stopping, it might because the liveness don't get response 200, because the web didn't up succesfully, it's not because of the java application, the problem with that container directly.
  - k8s readiness verify that the backend (in our case, "/" path) not response 200, and that might be because problem directly in the java app.
  - in route "/" in your ingress you can see the message of java app.

the containers (sidecar and java app) sharing volume in pod spec definition (deployment.yaml), the javaapp, up, and if the run success, it throw the output to the shared volume, and from the shared volume the sidecar pulls the data, just when that's success the readiness work and the ingress will send the traffic into the sidecar service, therfore if you can't see the web in ingress, it might because of it, try to get in sidecar container and verify that the txt file in that place (/usr/share/output.txt).

all the wrote above, assume that you are using the default values that comes with the project, and follow the guide to install it.




### requirements before you create helm release:
1. go to 
```
└── sidecar
    ├── Dockerfile
    ├── hello.py
    └── requirements.txt
```
and create docker image using that docker file, thats your sidecar from now, i'll talk about it later.

2. go to
```
.
├── Dockerfile
```
and create the java image


give thats artifacts name and upload it to your repository, after that update the values.yaml with images name.
java app in: java.javaapp.image.name (update also the tag that you chose).
sidecar in: java.sidecar.image.name (update also the tag that you chose).





### install helm release:

all the wrote bellow, based on the default values in values.yaml, if you use other values, change it also there.
let's start!!



1. create minikube or eks cluster then using the following commands:

2. choose node you want to deploy on it.
kubectl get nodes

3. label it, so the nodeSelector will choose it.
kubectl label node <YOUR-NODE-NAME> environment=java

4. taint your node, that's how you verify that's just this deployment will be on it, without any other parasites pods.
kubectl taint node <YOUR-NODE-NAME> env=java:NoExecute

5. create secrets.yaml with your docker credentials and put it in ./helm/templates/
run this command to extract your docker credentials and copy the output:
cat ~/.docker/config.json | base64

use this template:
```
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.java.imagePullSecrets }}
  namespace: {{ .Values.java.namespace }}
data:
  .dockerconfigjson: |
   <BASE 64 encoded docker credentials here>
type: kubernetes.io/dockerconfigjson
```

if you are using git, make sure the name of secret.yaml in your .gitignore, to make sure you don't upload it by mistake, if you cloned my project, it's already there.

6. go to ./ingress-nginx/README.md and follow this guide

7. go to ./helm and write the following command to create helm release

8. wait few seconds then check your ingress host url, congrats!!!!


### Deployment Strategy:
this deployment using rolling update strategy, what means that when you upgrade the helm release, k8s will up and down pods gradually.
you can define the maxsurge and maxunavailable in values.yaml.
maxsurge means the amount of pods that you allow k8s upload more than the replicas you defined while the rolling update.
maxunavailable means the amount of pods that are replaced in the rolling update that you allow k8s to kill at any given time.

### Folder Tree Reference:

```
.
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
└── sidecar
    ├── Dockerfile
    ├── hello.py
    └── requirements.txt

```
