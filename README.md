# Kubernetes the easy way
Ansible template to create kubernetes cluster with the following specs:
* Kubernetes 1.15.5
* Latest Flannel
* CNI 0.8.2
* CRI 1.15.0
* runc v1.0.0-rc8
* containerd 1.2.9 / 1.3.2
* etcd v3.3.15
* core-dns 1.6.2
* metrics-server
* Haproxy & keepalived
* Secure communication between component
* playbook for renewing certificate

### Testing in
* 3 etcd nodes
* 3 master nodes
* 3 worker nodes
* Ubuntu 18.04

## Step Installation
* Prepare deployer nodes (ansible is installed in here)
```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```
* Make sure deployer have root access into all nodes (tips using ssh-copy-id)
```
ssh-copy-id root@deployer
ssh-copy-id root@etcdX
ssh-copy-id root@masterX
ssh-copy-id root@workerX
```
* Clone this repository
```
git clone https://github.com/zufardhiyaulhaq/kubernetes-the-easy-way-with-ansible.git
```
* Change some variable
```
group_vars/all.yml
group_vars/master.yml
hosts/hosts
```
* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
```

### Additional Setup
* [metrics-server](https://github.com/zufardhiyaulhaq/kubernetes-the-easy-way-with-ansible/blob/master/additional_setup/metrics-server.md)
* [Private Insecure Registry](https://github.com/zufardhiyaulhaq/kubernetes-the-easy-way-with-ansible/blob/master/additional_setup/insecure-registry.md)