# HELM Project

## Overview:
This directory includes helm templates for a Java application includes some extensions.

### Extensions:
* Sidecar Container: The sidecar is a lightweight Python Flask application designed to:
  * Monitor the Java application's output by reading from a shared volume.
  * Provide health endpoints:
    * /health: Liveness probe.
    * /ready: Readiness probe, which checks the Java application's status.
      Note: For production environments, consider replacing Flask with a production-ready WSGI server like Gunicorn.

* Ingress-Nginx: Access to the frontend is provided via ingress-nginx for streamlined monitoring and interaction.
  The deployment using an ngnix ingress controller to expose the application externally.


## Prerequisites
Before deploying the Helm chart, ensure the following:

### Docker images

* Build and push the Java application Docker image via [Dockerfile](https://github.com/ishimto/maven-hello-world/blob/master/Dockerfile) or use the [CI/CD](https://github.com/ishimto/maven-hello-world/blob/master/README.md).
* Build and push the Sidecar Docker image via [Dockerfile](https://github.com/ishimto/maven-hello-world/blob/master/helm/sidecar/Dockerfile).


### values.yaml
Set the image names and tags for both the Java application and Sidecar containers.


### Ingress-NGINX Controller

Install the NGINX Ingress Controller in your Kubernetes cluster. Refer to the [Ingress-NGINX Installation Guide](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)

Minikube:  [Ingress-NGINX Installation Guide](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)


## Helm Release Installation Steps


1. Select a Node for Deployment

Identify the node where you want to deploy the application:

```
kubectl get nodes
```


2. Label the Node

Assign a label to the chosen node to target it for deployment:

```
kubectl label node <YOUR-NODE-NAME> environment=java
```

4. Taint the Node

Taint the node to ensure exclusive deployment, preventing other pods from being scheduled on it:

```
kubectl taint node <YOUR-NODE-NAME> env=java:NoExecute
```

5. Create Docker Registry Secret

Generate a Kubernetes secret containing your Docker registry credentials:

```
cat ~/.docker/config.json | base64
```

Create a secrets.yaml file in the ./helm/templates/ directory with the following content:

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

Note: Add secrets.yaml to your .gitignore file to prevent committing sensitive information.

6. Deploy the Helm Chart

```
helm install [your-release-name] .
```

7. Verify Deployment

After a few moments, verify that the application is accessible via the configured Ingress host URL.


8. Upgrade the Release (If Needed)

If you make changes to the Helm chart or configuration, upgrade the release:

```
helm upgrade [your-release-name] .
```

## Deployment Strategy:
This deployment using the RollingUpdate strategy to ensure zero downtime during updates.
You can configure the following parameters in values.yaml: 
* maxSurge: Specifies the maximum number of pods that can be created above the desired number of pods during an update.
* maxUnavailable: Specifies the maximum number of pods that can be unavailable during the update process.

Adjust these values to control the update behavior according to your requirements.
