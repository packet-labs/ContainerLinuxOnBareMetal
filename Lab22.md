# Use etcd to manage updates

## Goals

- Configure locksmithd to use etcd for locks
- Manual locks and unlock of servers

## Configure locksmithd

Let's add a `reboot_strategy: etcd-lock` into our Container Linux Config file, note that we need to keep the `etcd` section intact (token included).

Like so:

```yaml
etcd:
  version:                     "3.3.18"
  name:                        "mycluster"
  advertise_client_urls:       "http://{PRIVATE_IPV4}:2379"
  initial_advertise_peer_urls: "http://{PRIVATE_IPV4}:2380"
  listen_client_urls:          "http://0.0.0.0:2379"
  listen_peer_urls:            "http://{PRIVATE_IPV4}:2380"

locksmith:
  reboot_strategy: etcd-lock
```

```shell
ct -platform packet < locksmith.yaml > ~/ignition.json
sim-first-boot core@<server ip>
```

Once the server is restarted we should be able to use `locksmithctl` to verify the status:

```console
core@flatcar01-ams1-01 ~ $ locksmithctl status
Available: 1
Max: 1
```

The default configuration will make sure that at most 1 server at a time will be rebooted. you could increase this with `locksmithctl set-max`.
