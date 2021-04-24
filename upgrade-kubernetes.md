# Upgrade Kubernetes

### Upgrade from v1.18.7 to 1.19.10

Please make sure you enable `kubernetes.certificate.createClientKubeconfig` when bootstraping the cluster. This will allow deployer to access kubernetes cluster for cordoning purpose.

If you manage not enable this. You can copy the `admin.kubeconfig` from `{{ kubernetes.certificate.directory}}/kubeconfig` directory to `/home/{{ user }}/.kube/config` and make sure you can access Kubernetes.

### Upgrade from v1.18.6 to v1.18.7

Upgrading to 1.18.7 is breaking change from 1.18.6 because there is a change in the PKI. in 1.18.6 I use Kelsey Kubernetes hard way to generate the PKI. We try to move into the best practice guide https://kubernetes.io/docs/setup/best-practices/certificates.

group_vars Change log:

- add `kubernetes.components.encryptionProvider`
- add `infrastructure.ca.intermediateExpireTime`

currently there is no way to upgrade from v1.18.6 to v1.18.7 because there is a problem with etcd.
