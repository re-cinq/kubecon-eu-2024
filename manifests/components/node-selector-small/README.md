# Node pool selector

The GKE cluster we are running has different node pools of various sizes. We have setup 
`small-nodes` and `medium-nodes` node pools running `e2-standard-4` and `e2-standard-8` respectively.

To deploy the microservice demo to a specific node pool the `nodeSelector` field for the pod must point
to the node pool name:

```
apiVersion: v1
kind: Deployment
metdata:
  name: name
spec:
  template:
  spec:
    nodeSelector:
      cloud.google.com/gke-nodepool: small-nodes
```
note: The value for the `name` field does not matter because the patch type will target all Deployment types, no matter the name.

Instead of manually updating each deployment with the node selector, we have automated this by adding
it as a kustomize component  [Kustomize](../..).

First specify the node pool name in the `node-selector-patch.yaml` file. Replace `small-nodes` with whatever node pool name you have choosen: 
```bash
sed -i "s/cloud.google.com\\/gke-nodepool:.*$/cloud.google.com\\/gke-nodepool: small-nodes/" components/node-selector/node-selector-patch.yaml
```
This will update the `nodeSelector: <VAL>` in the node-selector-patch.yaml with whatever value you put as VAL.


From the `kustomize/` folder at the root level of this repository, execute this command:

```bash
kustomize edit add component components/node-selector
```

This will update the `kustomize/kustomization.yaml` file which could be similar to:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- base
components:
- components/node-selector
```
You can locally render these manifests by running `kubectl kustomize .` as well as deploying them by running `kubectl apply -k .`.

