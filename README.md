# KubeCon CloudNativeCon EU 2024 - Saving the Planet One Cluster at a Time

For our experiment we have setup four scenarios

- Microservices using small nodes 
- Microservices using big nodes
- A Monolith using Small nodes
- A monolith using big nodes 

The idea behind this demonstartion is to show the affect of energy
proportionality (i.e how utilized a node is) and the emissions that are
generated from each scenario 

This repository is for anyone that wants to replicate our demonstration

## Repository Layout

### Terraform

make sure the following APIs are enabled:

- Compute Engine API 
- Cloud Resource Manager API
- Cloud DNS API 
- Identity and Access Management (IAM) API
- Kubernetes Engine API

### Manifests

Services for the cluster have been installed with manifests based on the instruction guides for
each service. We have tried to make the installation as simple as possible, so in order to deploy the stack, you can simply run:

```bash
kubectl apply -k manifests
```

This should set up the experiment.

**NOTE:** we ran this demonstration on GKE therefore the node selection setup
is based on how the cluster is generated in the [terraform](./terraform)
directory

#### Kepler

Installed Kepler the GKE cluster using manifests: https://sustainable-computing.io/installation/kepler/

1. Install monitoring stack
   - [Prometheus with operator](https://sustainable-computing.io/installation/kepler/#deploy-the-prometheus-operator)
   - kepler-exporter for grafana (requires `yq`)

2. Clone the kepler repo and run script to build manifests with the prometheus deployment from step 1:
 `make build-manifest OPTS=PROMETHEUS_DEPLOY`

Note: We have put our generated manifest files for the kepler deployment in the `manifests/kepler` dir

3. By default kepler uses eBPF to access power consumption values, but since we are running in GKE and the kernel is
   inaccessible, we need to enable the machine learning [regression model](https://sustainable-computing.io/kepler_model_server/get_started/#step-2-learn-how-to-obtain-power-model).
   To do this edit the ConfigMap `kepler-cfm` in `deployment.yaml` file and update the `MODEL_CONFIG` value with the line `MODEL_SERVER_ENABLE=true`, so it looks like:
   ```
     MODEL_CONFIG: |
       CONTAINER_COMPONENTS_ESTIMATOR=false
       MODEL_SERVER_ENABLE=true
   ```

4. Make sure all of the kepler services deployed without issue to the kepler ns:
 `kubectl get all -n kepler`

5. Check the prometheus exporter is collecting metrics via kepler
 `kubectl -n monitoring port-forward svc/prometheus-k8s 9090`
  Check the state is `up` for the `kepler-exporter`

6. Create Grafana dashboards based on collected data

#### Microservice-demo

The [microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo) from GCP is a simple microservice
boutique webshop.

The README.md in manifests/microservice-demo/ explains how to run it yourself
Additionally, we added a kustomize overlay to specify a specific GKE nodepool
to run the microservice on. More information on that can be found at manifests/microservice-demo/components/node-selector

#### Monolith Demo

We where not able to find a good example of a monolithic demo. Therefore as
this is not a comparison between monoliths and microservices, but rather trying
to understand how a single deployable large system contributes to emissions and
where it performs better, we decided to take the previously described
microservice demo and create a single pod with all the components in one. We
understand that this is by no means an "optimized" setup, but it will be able
to give us the data that we need. 

The [README](manifests/bases/monolith-demo/README.md) for the Monlith Demo explains how to run it yourself
Additionally, we added a kustomize overlay to specify a specific GKE nodepool
to run the monolith on. More information on that can be found in the components [README](manifests/components/node-selector-big/README.md)
