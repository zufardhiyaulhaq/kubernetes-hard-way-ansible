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
* 3 etcd nodes, 3 master nodes, 3 worker nodes
* 3 etcd & master nodes, 3 worker nodes
* Ubuntu 18.04

## Step Installation
* Prepare deployer nodes (ansible is installed in here)
```
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
```
* Make sure deployer have access into all nodes (tips using ssh-copy-id)

please make sure that user have privilege access, you can add the user in sudoers files, after bootstrap is done, fell free to remove that.
```
ssh-keygen

# copy to deployer itself
ssh-copy-id ubuntu@10.102.102.40

# copy to etcd node
ssh-copy-id ubuntu@10.102.102.10
ssh-copy-id ubuntu@10.102.102.11
ssh-copy-id ubuntu@10.102.102.12

# copy to master node
ssh-copy-id ubuntu@10.102.102.20
ssh-copy-id ubuntu@10.102.102.21
ssh-copy-id ubuntu@10.102.102.22

# copy to master node
ssh-copy-id ubuntu@10.102.102.30
ssh-copy-id ubuntu@10.102.102.31
ssh-copy-id ubuntu@10.102.102.32
```
* disable ansible hostkey checking
```
vi ~/.ansible.cfg

[defaults]
host_key_checking = False
```
* Clone this repository
```
git clone https://github.com/zufardhiyaulhaq/kubernetes-hardway-ansible.git
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
* [Private Insecure Registry](additional_setup/insecure-registry.md)
* [Renew Certificate](additional_setup/insecure-registry.md)
* [Add new Worker](additional_setup/insecure-registry.md)
