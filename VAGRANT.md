## Step Installation
* Clone repository
```
git clone https://github.com/zufardhiyaulhaq/kubernetes-hardway-ansible.git
cd kubernetes-hardway-ansible
```

* Change some Vagrant variable if needed
```
cat Vagrantfile
vi Vagrantfile
```

* Start Vagrant
```
vagrant up
```

* SSH to deployer node
```bash
ssh vagrant@10.200.100.30
```

* Make sure deployer have access into all nodes
```bash
ssh-keygen

# copy to deployer itself
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.30

# copy to etcd & master node
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.10
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.11
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.12

# copy to master node
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.20
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.21
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no vagrant@10.200.100.22
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
cd kubernetes-hardway-ansible
```

* Change some variable if needed
```
vi group_vars/all.yml
vi hosts/hosts
```

* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
```

* Copy client.kubeconfig from deployer nodes and merge with your kubeconfig
This needed if you want to access kubernetes from other node rather than deployer mode
```
mkdir /tmp/kubeconfig
scp vagrant@10.200.100.30:~/.kube/config /tmp/kubeconfig/config

cp ~/.kube/config ~/.kube/config.bak

KUBECONFIG=~/.kube/config:/tmp/kubeconfig/config kubectl config view --flatten > /tmp/merge
cp /tmp/merge ~/.kube/config
```
