# Upgrade Kubernetes
Upgrading to 1.18.7 is breaking change from 1.18.6 because there is a change in the PKI. in 1.18.6 I use Kelsey Kubernetes hard way to generate the PKI. We try to move into the best practice guide https://kubernetes.io/docs/setup/best-practices/certificates. Please notice this can affect all of the current deployment. This will create a new root CA, kubeconfig, etc.

group_vars Change log:
- add `kubernetes.components.encryptionProvider` 
- add `infrastructure.ca.intermediateExpireTime`

* Backup existing certificate directory
```
mv ~/kubernetes-certificate ~/kubernetes-certificate-backup
```

* bump local repository & make changes in group_vars/all.yml
```
git fetch --all
git checkout --track origin/<TAG>

vi group_vars/all.yml
```

* get old encryption key & edit group_vars
```
sudo apt install jq
pip3 install yq
cat ~/kubernetes-certificate/encryption-config.yml | yq -r .resources[0].providers[0].aescbc.keys[0].secret

vi group_vars/all.yml
kubernetes.components.encryptionProvider.key with old encryption key
```

* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
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
