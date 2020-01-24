# Insecure Private Registry
If you need private registry inside the kubernetes, do the following in all nodes
- set up hostname
```
nano /etc/hosts

registry_IP registry_HOSTNAME
```
- add registry containerd configuration (/etc/containerd/config.toml)
```
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""

    [plugins.cri.registry]
      [plugins.cri.registry.mirrors]
        [plugins.cri.registry.mirrors."registry_HOSTNAME:5000"]
          endpoint = ["http://registry_HOSTNAME:5000"]
```
- restart containerd