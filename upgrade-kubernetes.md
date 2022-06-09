# Upgrade Kubernetes

### Upgrade from v1.21.7 to v1.22.10

#### Verifying Deprecated Object
* download & install kubent
```
sh -c "$(curl -sSL https://git.io/install-kubent)"
```

* verify and upgrade your object
```
kubent
6:58AM INF >>> Kube No Trouble `kubent` <<<
6:58AM INF version 0.4.0 (git sha 3d82a3f0714c97035c27374854703256b3d69125)
6:58AM INF Initializing collectors and retrieving data
6:58AM INF Retrieved 34 resources from collector name=Cluster
6:58AM INF Retrieved 0 resources from collector name="Helm v2"
6:58AM INF Retrieved 598 resources from collector name="Helm v3"
6:58AM INF Loaded ruleset name=custom.rego.tmpl
6:58AM INF Loaded ruleset name=deprecated-1-16.rego
6:58AM INF Loaded ruleset name=deprecated-1-22.rego
```

#### Upgrade step
* SSH to deployer node
```bash
ssh vagrant@10.200.100.30
```

* Go to `kubernetes-hardway-ansible` directory, checkout to master
```
git fetch --all
git checkout --track origin/v1.22.10
```

* Adjust variable in the group_vars
```
vi group_vars/all.yml
```

* Adjust Kubernetes host and nodes
```
vi hosts/hosts
```

* Run ansible
```
ansible-playbook upgrade-kubernetes.yml -i hosts/hosts
```

* Verify version
```
kubectl version
kubectl get nodes

kubectl describe deployment coredns --namespace kube-system | grep Image
kubectl get daemonset kube-flannel-ds --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
```

### Upgrade from v1.20.12 to v1.21.7

#### Upgrade step
* SSH to deployer node
```bash
ssh vagrant@10.200.100.30
```

* Go to `kubernetes-hardway-ansible` directory, checkout to master
```
git fetch --all
git checkout --track origin/v1.21.7
```

* Adjust variable in the group_vars
```
vi group_vars/all.yml
```

* Adjust Kubernetes host and nodes
```
vi hosts/hosts
```

* Run ansible
```
ansible-playbook upgrade-kubernetes.yml -i hosts/hosts
```

* Verify version
```
kubectl version
kubectl get nodes

kubectl describe deployment coredns --namespace kube-system | grep Image
kubectl get daemonset kube-flannel-ds --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
```

### Upgrade from v1.19.10 to 1.20.12

Please note that upgrading from v1.19.10 to v1.20.12 will also upgrade flannel, coredns, and metrics-server. Please test in staging or testing cluster before upgrading.

#### Upgrade step
* SSH to deployer node
```bash
ssh vagrant@10.200.100.30
```

* Go to `kubernetes-hardway-ansible` directory, checkout to master
```
git fetch --all
git checkout --track origin/v1.20.12
```

* Adjust variable in the group_vars
```
vi group_vars/all.yml
```

* Adjust Kubernetes host and nodes
```
vi hosts/hosts
```

* Run ansible
```
ansible-playbook upgrade-kubernetes.yml -i hosts/hosts
```

* Verify version
```
kubectl version
kubectl get nodes

kubectl describe deployment coredns --namespace kube-system | grep Image
kubectl get daemonset kube-flannel-ds --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
```

### Upgrade from v1.18.7 to 1.19.10

Please note that upgrading from v1.18.7 to v1.19.10 will also upgrade flannel, coredns, and metrics-server. Please test in staging or testing cluster before upgrading.

#### Upgrade step
* SSH to deployer node
```bash
ssh vagrant@10.200.100.30
```

* Go to `kubernetes-hardway-ansible` directory, checkout to master
```
git fetch --all
git checkout --track origin/v1.19.10
```

* Adjust variable in the group_vars
```
vi group_vars/all.yml
```

* Adjust Kubernetes host and nodes
```
vi hosts/hosts
```

* Run ansible
```
ansible-playbook upgrade-kubernetes.yml -i hosts/hosts
```

* Verify version
```
kubectl version
kubectl get nodes

kubectl describe deployment coredns --namespace kube-system | grep Image
kubectl get daemonset kube-flannel-ds --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
```

### Upgrade from v1.18.6 to v1.18.7

Upgrading to 1.18.7 is breaking change from 1.18.6 because there is a change in the PKI. in 1.18.6 I use Kelsey Kubernetes hard way to generate the PKI. We try to move into the best practice guide https://kubernetes.io/docs/setup/best-practices/certificates.

group_vars Change log:

- add `kubernetes.components.encryptionProvider`
- add `infrastructure.ca.intermediateExpireTime`

currently there is no way to upgrade from v1.18.6 to v1.18.7 because there is a problem with etcd.
