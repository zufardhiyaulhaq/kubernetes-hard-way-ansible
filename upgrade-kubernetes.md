# Upgrade Kubernetes
You can simply run upgrade-kubernetes.yml to upgrade the kubernetes version to v1.18.7 and using hosts files same like deploying new Cluster. You need to run this on the deployer node.

* Run ansible
```
ansible-playbook upgrade-kubernetes.yml -i hosts/hosts
```
