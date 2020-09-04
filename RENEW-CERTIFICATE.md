# Renew Certification
You can simply run renew-certificate.yml and using hosts files same like deploying new Cluster. You need to run this on the deployer node.
* Run ansible
```
ansible-playbook renew-certificate.yml -i hosts/hosts
```

### Restart Kubernetes service etcd
```bash
systemctl restart etcd
```
### restarting kubernetes service master
```bash
systemctl restart kube-apiserver
systemctl restart kube-scheduler
systemctl restart kube-controller-manager
systemctl restart kubelet
systemctl restart kube-proxy
```

### restarting kubernetes service worker
```bash
systemctl restart kubelet
systemctl restart kube-proxy
```
