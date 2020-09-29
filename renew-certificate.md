# Renew Certification
You can simply run renew-certificate.yml and using hosts files same like deploying new Cluster. You need to run this on the deployer node.

* Run ansible
```
ansible-playbook renew-certificate.yml -i hosts/hosts
```

* delete all service account
```
for i in $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}'); do kubectl get secrets --namespace=${i} --no-headers | grep "kubernetes.io/service-account-token" | awk '{print $1}' | xargs -I {} kubectl delete secret --namespace=$i {}; done
```

* restart kube-controller-manager and kube-apiserver
```
sudo systemctl restart kube-controller-manager
sudo systemctl restart kube-apiserver
```

* delete all pods
```
kubectl delete pods --all --all-namespaces
```
