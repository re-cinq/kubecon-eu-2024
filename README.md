# kubecon-eu-2024

## Terraform

make sure the following APIs are enabled:

- Compute Engine API 
- Cloud Resource Manager API
- Cloud DNS API 
- Identity and Access Management (IAM) API
- Kubernetes Engine API

## Kepler

Installed Kepler the GKE cluster using manifests: https://sustainable-computing.io/installation/kepler/

1. Install monitoring stack
   - Prometheus with operator: https://sustainable-computing.io/installation/kepler/#deploy-the-prometheus-operator
   - kepler-exporter for grafana (requires `yq`)

2. Clone the kepler repo to build manifests with the prometheus deployment from step 1
 `make build-manifest OPTS=PROMETHEUS_DEPLOY`

3. Make sure all of the kepler services deployed without issue to the kepler ns:
 `kubectl get all -n kepler`

4. Check the prometheus exporter is collecting metrics via kepler
 `kubectl -n monitoring port-forward svc/prometheus-k8s 9090`
  Check the state is `up` for the `kepler-exporter`

5. Create Grafana dashboards based on collected data
