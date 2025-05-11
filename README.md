# GitHub Actions - Maven CI/CD

## Overview

This repository includes a full CI/CD pipeline for a Java application using GitHub Actions, Maven, Docker, and Helm.
The goal is to automate build, test, and deployment processes, ensuring efficiency and reliability across the Software Development Life Cycle (SDLC).


## Workflow Overview
This repository includes a GitHub Actions workflow defined in [cicd.yaml](https://github.com/ishimto/maven-hello-world/blob/master/.github/workflows/cicd.yaml), which automates the CI/CD process for a Java (Maven) application.

The workflow comprises two primary jobs:
* Stage Deployment
* Production Deployment

Each job is triggered based on specific branch conditions and performs a comprehensive sequence of operations, including building the application, running tests, extracting artifacts, managing Docker images, and deploying to designated environments.

The workflow leverages Docker Compose for container orchestration and includes health checks to ensure the stability of deployments. 

Additionally, it implements a rollback mechanism to revert to the previous stable version in case of deployment failures.

By integrating these processes, the workflow facilitates continuous integration and continuous deployment, ensuring that code changes are automatically tested and deployed in a reliable and efficient manner.


## Trigger Conditions
The workflow is triggered on push events to the following branches:

* master
* stage
* Any branch prefixed with test
Commits containing the message: NORUN, will skip the workflow execution (If you want to not run and have a special documented commit that you can bold it for later and go back to, otherwise use the default github actions options like skip ci).

## Environment Variables & Secrets
The following environment variables and secrets are required:

### Environment Variables (Defined in the workflow)
* DOCKER_IMAGE – Full path to the Docker image repository.

* CONTAINER_NAME – Docker container name used during testing and deployment.

### GitHub Secrets Required
* DOCKER_USERNAME – Docker Hub username.
* DOCKER_TOKEN – Docker Hub access token.
* DOCKER_REPO – Docker repository name (e.g., username/repo).
* EC2_USER – SSH user for EC2 access.
* EC2_STAGE_KEY – SSH private key for stage server.
* EC2_STAGE_HOST – IP address of the stage EC2 server.
* EC2_PROD_KEY – SSH private key for production server.
* EC2_PROD_HOST – IP address of the production EC2 server.

## Artifacts and Docker Tags

### Maven
Maven JAR files are extracted from the container and uploaded as workflow artifacts for debugging porpuses.

### Docker images are tagged with:
* Commit SHA.
* Maven version.
* latest, rollback, or stable.

### HELM DOC
[redirect helm doc](https://github.com/ishimto/maven-hello-world/blob/master/helm/README.md)
