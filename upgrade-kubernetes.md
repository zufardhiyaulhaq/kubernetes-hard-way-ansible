# Upgrade Kubernetes
Upgrading to 1.18.7 is breaking change from 1.18.6 because there is a change in the PKI. in 1.18.6 I use Kelsey Kubernetes hard way to generate the PKI. We try to move into the best practice guide https://kubernetes.io/docs/setup/best-practices/certificates. Please notice this can affect all of the current deployment. This will create a new root CA, kubeconfig, etc.

* Backup existing certificate directory
```
cp ~/kubernetes-certificate kubernetes-certificate-backup
```

* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
```
