# Kubernetes Hard Way Ansible
Ansible template to create kubernetes cluster with the following specs:
* Kubernetes 1.18.7
* Flannel v1.12.0
* CNI v0.8.6
* CRI v1.18.0
* runc v1.0.0-rc91
* containerd v1.3.6
* etcd v3.4.10
* core-dns 1.7.0
* metrics-server v0.3.7
* Haproxy & keepalived
* Secure communication between component

### Additional Feature
* OIDC supported
* MetalLB supported
* Vagrant installation supported
* Insecure Registry supported
* Renewing certificate playbook
* Adding worker node playbook

### Tested Environment
* Ubuntu 18.04
    * 3 master nodes, 3 worker nodes
    * 3 etcd nodes, 3 master nodes, 3 worker nodes

## Step Installation
Execution happen on the deployer node. All the ceritificate generated and store in the deployer node. The deployer node cannot be deleted if you want to renew certificate or extending kubernetes worker node. All this step executed in the deployer node.

* Prepare ansible
```bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
```
* Make sure have access into all nodes

please make sure that <user> have privilege access, you can add the user in sudoers files, after bootstrap is done, fell free to remove that.
```bash
ssh-keygen

# copy to deployer itself
ssh-copy-id <user>@10.102.102.40

# copy to etcd node
ssh-copy-id <user>@10.102.102.10
ssh-copy-id <user>@10.102.102.11
ssh-copy-id <user>@10.102.102.12

# copy to master node
ssh-copy-id <user>@10.102.102.20
ssh-copy-id <user>@10.102.102.21
ssh-copy-id <user>@10.102.102.22

# copy to master node
ssh-copy-id <user>@10.102.102.30
ssh-copy-id <user>@10.102.102.31
ssh-copy-id <user>@10.102.102.32
```

* disable ansible hostkey checking
```bash
vi ~/.ansible.cfg

[defaults]
host_key_checking = False
```

* Clone this repository
```bash
git clone https://github.com/zufardhiyaulhaq/kubernetes-hardway-ansible.git
```

* Change some variable
```
vi group_vars/all.yml
vi hosts/hosts
```

* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
```

Please backup certificate directory in the deployer node!

### Additional Setup
* [OIDC](additional_setup/oidc.md)
* [metalLB](additional_setup/metallb.md)
* [Private Insecure Registry](additional_setup/insecure-registry.md)
* [Renew Certificate](renew-certificate.md)
* [Add new Worker](new-worker.md)
* [Upgrade Kubernetes](upgrade-kubernetes.md)
