w# Metrics Server
Metrics server is a incubating project in Kubernetes to enable Kubernetes horizonal pod scaling.

### Deploy metrics-server
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
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
