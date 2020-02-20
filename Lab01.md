# Lab 01 - Lab Assignment and Verification

## Lab Assignment & Credentials

On the whiteboard/projector, there will be a link to an etherpad listing all the available lab environments along with the default password. Follow the link and write your name alongside a lab number (i.e. lab03 - John Doe).

Take note of the name of the "lab master" server on the whiteboard/projector. This will be the jump server from where you will access

If you ever need a new lab environment, return to this page and simply assign yourself a new one. Mark any old/broken lab environments as "broken/recycle" and it will be rebuilt.

## Background

We've taken the liberty of spinning up some bare metal infrastructure for you to use in this lab.
Each student has been allocated a number of bare metal hosts with Flatcar Linux already installed.
In this first lab, you'll be verifying that you can log into all the physical bare metal.

## Deployed Bare Metal per Lab

| Node     | CPU cores      | Memory (GB) | Boot (GB SSD) | Storage (GB SSD) | Details
|----------|----------------|-------------|---------------|------------------|---------
| node1    | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | None             |[t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)
| node2    | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | None             |[t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)
| node3    | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | None             |[t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)

## Layout

```text
                                     +--------------------+
                                     |                    |
                                     |                 +--v-------------------+
                                     |                 | node1                |
                                     |                 | student dedicated    |
+----------------------+   SSH       |                 | login: core          |
|                      +-------------+                 +----------------------+
| Lab Master           |
| Terraform            |            SSH                +----------------------+
| shared by students   |------------------------------>+ node2                |
| login: labXX         +---v                           | student dedicated    |
+----------------------+   |                           | login: core          |
                           |                           +----------------------+
                           |
                           |                           +----------------------+
                           |                           | node3                |
                           |                           | student dedicated    |
                           +-------------------------->+ login: core          |
                                    SSH                +----------------------+

```

## Lab Master Access

With your assigned lab username (i.e. lab03), log into the lab master server using your assigned lab and the password. You'll need to use a SSH client (i.e. PuTTy).

```shell
ssh <your_lab_username>@<lab_master_server>
```

## Verify Lab Hosts

Do a quick check that all your assigned hosts are available. These Ansible commands are to be run on the lab master.

### List Lab Hosts

You should have a total of two hosts assigned to you.

```shell
ansible-inventory -i inventory.ini --list
```

### Verify Lab Host Networking

Verify that all machines return a ping OK.

```shell
ansible -i inventory.ini all -m raw -a "echo pong" -o
```

### Verify SSH Access

Lookup the master node IP and verify that SSH works.

```shell
ssh node1
```

## Moving Forward

If you have a correct number of hosts and all are responding to ping, please proceed to the next lab. If you are missing machines or they are not responding correctly, please mark this lab as broken on the etherpad, pick another lab from the etherpad, and repeat the lab verification steps.

## Next Steps

Once you're done, proceed to [Lab02](Lab02.md)
