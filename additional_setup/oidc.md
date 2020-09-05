# OIDC
Please setup OIDC in the `group_vars/all.yml`. If you already setup and running the bootstraping. In cases of OIDC, you only need to apply RBAC for accessing Kubernetes cluster from OIDC. For example:

```
cat <<EOF | kubectl apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: oidc-kubernetes-admin
subjects:
- kind: Group
  name: oidc:/kubernetes-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: oidc-kubernetes-view
subjects:
- kind: Group
  name: oidc:/kubernetes-viewer
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:public-info-viewer
  apiGroup: rbac.authorization.k8s.io  
EOF
```
