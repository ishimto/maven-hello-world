# Prometheus

# folder tree:
```
.
├── helm-templates
│   └── annotaions.yaml
└── README.md
```

* create namespace:
kubectl create namespace monitoring


* Get Repository:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


* Install Chart:
helm install [RELEASE_NAME] prometheus-community/prometheus --namespace monitoring



# Service Discovery



go to: ./helm-templates/annotaions.yaml
copy the annotations into your deployment in spec.template.metadata.annotations to expose your metrics in pod level.

it should looks like this:
```
spec:
  ...
  selector:
  ...
  template:
  ...
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: "/metrics"
        prometheus.io/port: "{{ .Values.app.containerPort }}"
    ...
```

Once installed you can get in prometheus-server service and watch your metrics.


# Grafana


In order to manage your metrics better, install grafana:

* Get Repository:
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update


* Install Chart:
helm install [RELEASE_NAME] grafana/grafana --namespace monitoring


# Get credentials:
default:
username: admin
password: kubectl get secret --namespace monitoring [RELEASE_NAME] -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

not default:
add to values.yaml:
adminUser: <YOUR ADMIN USER_NAME>
adminPassword:  <YOUR ADMIN PASSWORD>

update chart:
helm upgrade [RELEASE_NAME] grafana/grafana -f values.yaml -n monitoring


# Access Grafana
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=[RELEASE_NAME]" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000
Navigate to 127.0.0.1:3000 in your browser.

there is an other option using Open-Lens tool to do port-forwoard easier.
In order to expose it out of your cluster, use ingress or service type LoadBalancer.
