# Add New Worker Node
* Make sure deployer have root into deployer itself and new worker node
```
ssh-copy-id root@deployer
ssh-copy-id root@workerX
```
* Change some variable
```
hosts/hosts.new.worker
```
* Run ansible with inventory files spesific for adding worker
```
ansible-playbook add-worker.yml -i hosts/hosts-new-worker
```
* After new node is deployed, dont forget to append `worker` section in `hosts/hosts` file with new worker IP Address