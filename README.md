# Kubernetes the easy way
Ansible template to create kubernetes cluster with the following specs:
* Kubernetes 1.16.0
* Latest Docker
* Latest Flannel
* CNI 0.7.5
* CRI 1.14.0
* etcd 3.3.9
* core-dns 1.6.2
* metrics-server
* Haproxy & keepalived
* Secure communication between component

### Testing in
* 3 etcd nodes
* 3 master nodes
* 3 worker nodes
* Ubuntu 18.04

## Step
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
* [metrics-server](additional_setup/metrics-server.md)