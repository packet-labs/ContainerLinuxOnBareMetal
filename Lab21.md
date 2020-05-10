# Use etcd key value store

## Goals

- List, get and set keys

## Configure locksmithd

Use `etcdctl ls /` to list available keys (should be empty). Then let's set a key with `etcdctl set /key value`, then we can get that key on any node with `etcdctl get /key`
