# Etcd cluster

## Goals

- Understand and use etcd cluster
- Joint nodes to an etcd cluster

## etcd

Distributed reliable key-value store for the most critical data of a distributed system.

etcd needs to be aware of the IP of the server, for that exact purpose Container Linux Config allows to inject dynamic data (such as IP).

Each cluster needs a discovery token from <https://discovery.etcd.io/new?size=3>

Create a file `etcd.yaml` with the following content:

```yaml
etcd:
  version:                     "3.3.18"
  name:                        "mycluster"
  discovery: https://discovery.etcd.io/<token>
  advertise_client_urls:       "http://{PRIVATE_IPV4}:2379"
  initial_advertise_peer_urls: "http://{PRIVATE_IPV4}:2380"
  listen_client_urls:          "http://0.0.0.0:2379"
  listen_peer_urls:            "http://{PRIVATE_IPV4}:2380"
```

Then transpile it with the `ct` command, but this time specifying the `-platform packet` parameter.

```shell
ct -platform packet < etcd.yaml > ~/ignition.json
```

Now let's simulate a first reboot with `sim-first-boot core@<server ip>` then SSH back into the server once it's ready to go.

You should see a new `/etc/systemd/system/etcd-member.service.d/20-clct-etcd-member.conf` file containing environment variables like `${COREOS_PACKET_HOSTNAME}`, those environment variables are defined in `/run/metadata/coreos`.

Ignition starts the etcd process in an `rkt` container, you can list them with:

```console
core@flatcar01-ams1-01 ~ $ rkt list
UUID  APP IMAGE NAME   STATE CREATED  STARTED  NETWORKS
058f585a etcd quay.io/coreos/etcd:v3.3.18 running 3 minutes ago 3 minutes ago
```

Let's check if the etcd cluster is healthy with:

```consoleolle
core@flatcar01-ams1-01 ~ $ etcdctl  cluster-health
member e92006e42830ec6 is healthy: got healthy result from http://10.80.99.3:2379
cluster is healthy
```

## Join nodes to the etcd cluster

Now that the initial etcd cluster is up, let's join some more nodes. Use the same command as previously `sim-first-boot core@<server ip>`, but this time with the other servers. They will use the same `ignition.json` file as the first server but this time they will join the existing cluster.

While the servers reboot, we can follow the etcd cluster health with `watch etcdctl cluster-health` in the first server (`ctrl+c` to exit).
