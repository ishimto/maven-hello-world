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




## Sementic Versioning
Regardless the code you write, it's better to version it so you can know rollback in case it needed or manage few versions if it needed, it also good for docs.
There are a lot of versioning methods, in our project we used sementic version, that build from 3 numbers splitted with ".", like "1.0.0" or "4.2.3" etc..
but WAIT!!!!! i wrote 1.0.0 then 4.2.3, what each number mean?
so.. it's splitted by that method:   Major.Minor.Patch
* Major version incremented when there are breaked changes the existing api.
* Minor version incremented when there are changes but not breaked one, like adding more features.
* Patch version incremented when there are bug fixes and non functionallity changed.


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

### WHY WE NEED IT??
as mentiond above, maven is a build automation tool and project management for java project, but what does it mean??
before maven, we needed to:
* manage dependencies - install the JAR (libraries) of third party, save them in folder in out project, and if one library needs other we needed to understand it by ourself, and install the other depend library.
* build - before maven we needed to build scripts to build our project includes the following steps:
  clean, compile, test, package, install and deploy (sometimes also verify and validate as tests).
maven solves it with concept that calls LifeCycles and there are 3 types of lifecycles - default, clean, site.

### pom.xml
file xml that contains:
* metadata of the project - like version, artifact name (ID) etc..
* dependencies - maven will install it automaticlly, includes them nested dependencies (automation!!!)
* build process with plugins for each phase and them goals that will used includes versions
* repositories - where maven can install dependencies or plugins if needed (extended places and not just the default - maven central)
* distribution - tells maven where to publish the artifact like the JAR file, the credentials for destination saved in settings.xml in m2/.. local repository.
* properties - general variables that can be used over the pom file
etc..


### Plugins && Goals
plugins are the tools that actually runs the phases in the lifecycle, without them maven not have a real value.
each step in the lifecycle don't really know how to do things, it just "trigger" that run goal from plugin.
so what goal mean?
each plugin has goals, and each goals do specific action in the plugin.
lets take the plugin maven-compiler-plugin, thats the plugin that compiles the source code, you can use it: mvn maven-compiler-plugin:compile

maven has default plugins that it will run when you doing mvn <phase>, if you didn't specify in the pom.xml.
if you want to specify a specific version of plugin or running a specific plugin, you'll need to adding it into pom.xml
the order in pom.xml not say anything, maven still doing it by the order of lifecycle, unless you specify the phase in the plugin execution.


### Life Cycles
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

ENDS OF DEFAULT LIFECYCLE, now after i explained about it, it will be easier to understand what i meant before when i wrote "when you run phase it will run the all phases before until it and not just it" in thge first LifeCycles unit.


* clean:
thats lifecycle important if you run maven in the same environment over and over again, you clean the target directory, and let you to compile next time into clean environment.

* site:
that lifecycle responsible of create documents for the porject, create static sites in html format with information about the project.
the data for documents is taken from existing data like result of unitests if there are.
the documents saved in target/site

