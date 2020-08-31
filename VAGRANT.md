## Step Installation
* Start Vagrant
```
vagrant up
```

* SSH to deployer node
```bash
vagrant ssh kubernetes-deployer
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

* Clone this repository
```bash
git clone https://github.com/zufardhiyaulhaq/kubernetes-hardway-ansible.git
```

* Run ansible
```
ansible-playbook main.yml -i hosts/hosts
```
