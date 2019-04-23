# Metrics Server
Metrics server is a incubating project in Kubernetes to enable Kubernetes horizonal pod scaling.

The setup in this architecture is little bit difference, because API Server cannot connect into metrics-server pod directly.

### Step
#### Generate additional certificate
* Go into deployer node
```
cd certificate-template/
```
* Add this json template
```
cat > metrics-server-csr.json << EOF
{
  "CN": "aggregator",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "metrics-server",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF
```
* Generate certificate
```
cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=ca-config.json \
    -profile=kubernetes \
    metrics-server-csr.json | cfssljson -bare aggregator-proxy-client
```
### Copy certificate into Master
* Copy from deployer
```
scp ca.pem root@10.202.202.40:~/
scp aggregator-proxy-client.pem root@10.202.202.40:~/
scp aggregator-proxy-client-key.pem root@10.202.202.40:~/

scp ca.pem root@10.202.202.50:~/
scp aggregator-proxy-client.pem root@10.202.202.50:~/
scp aggregator-proxy-client-key.pem root@10.202.202.50:~/

scp ca.pem root@10.202.202.60:~/
scp aggregator-proxy-client.pem root@10.202.202.60:~/
scp aggregator-proxy-client-key.pem root@10.202.202.60:~/
```
* Create certificate directory
```
mkdir /var/lib/kubernetes/aggregator-ca/
```
* Copy into directory
```
cp ca.pem /var/lib/kubernetes/aggregator-ca/
cp aggregator-proxy-client.pem /var/lib/kubernetes/aggregator-ca/
cp aggregator-proxy-client-key.pem /var/lib/kubernetes/aggregator-ca/
```
### Edit kube-apiserver service
```
nano /etc/systemd/system/kube-apiserver.service
```
Add this following configuration
```
    --requestheader-client-ca-file=/var/lib/kubernetes/aggregator-ca/ca.pem \
    --proxy-client-cert-file=/var/lib/kubernetes/aggregator-ca/aggregator-proxy-client.pem \
    --proxy-client-key-file=/var/lib/kubernetes/aggregator-ca/aggregator-proxy-client-key.pem \
    --requestheader-allowed-names=aggregator \
    --requestheader-extra-headers-prefix=X-Remote-Extra- \
    --requestheader-group-headers=X-Remote-Group \
    --requestheader-username-headers=X-Remote-User \
    --enable-aggregator-routing=true \
```
### Restart API Server
```
systemctl daemon-reload
systemctl restart kube-apiserver
```
### Create RBAC
```
cat > rbac.yaml << EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: view-metrics
rules:
- apiGroups:
    - metrics.k8s.io
  resources:
    - pods
    - nodes
  verbs:
    - get
    - list
    - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: view-metrics
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view-metrics
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: aggregator
EOF
```
```
kubectl create -f rbac.yaml
```
### Deploy metrics-server
```
git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server
kubectl create -f deploy/1.8+/
```
### Checking
```
root@zu-master1:~# kubectl top pod --all-namespaces
NAMESPACE     NAME                              CPU(cores)   MEMORY(bytes)   
default       busybox-55f5d6ff67-7fmkl          0m           0Mi             
kube-system   coredns-6c868f76bc-68bt9          2m           8Mi             
kube-system   coredns-6c868f76bc-75rls          2m           8Mi             
kube-system   kube-flannel-ds-amd64-dkshf       2m           9Mi             
kube-system   kube-flannel-ds-amd64-k7qgl       2m           9Mi             
kube-system   kube-flannel-ds-amd64-p9b2p       1m           9Mi             
kube-system   metrics-server-6b4c9c9bf9-ddglp   1m           16Mi  
```