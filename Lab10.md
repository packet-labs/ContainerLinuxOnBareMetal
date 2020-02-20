# Lab 10 - The Transpiler

## Goals

- Understand and use the `ct` transpiler

## Configuration

Container Linux is configured using human readable Container Linux Configs (YAML based) which are then transpiled into machine readable instructions in Ignition format (JSON based).

The machine readable instructions are then executed by the server during the *first boot*.

The Lab Master server already has the transpiler installed: `ct`; it takes a Container Linux Config file in stdin and generated the corresponding Ignition instructions on stdout.

## Your first Ignition file

To get started we'll generate an Ignition config that does absolutly nothing.

```shell
ct -help
ct -pretty < /dev/null
```

## Simulate a first-boot

In real life, any change to the ignition config should trigger a complete redeploy of the server to achieve immutable infrastructure, but to accelerate things in this workshop we will *simulate* the first boot.

The simulation will trigger a reboot and use the `~/ignition.json` in your lab home directory.

Let's get started by making a simple Container Linux config file. Open `~/hello.yaml` with your favorite editor:

```yaml
storage:
  files:
    - path: /hello
      filesystem: root
      contents:
        inline: Hello world
      mode: 0644
```

Then let's transpile the Container Linux config file into an Ignition JSON file:

```shell
ct < ~/hello.yaml > ~/ignition.json
```

Then we need to simulate a first-boot on the server. Thankfully we have a small script available for that (you can check what it does with `/usr/local/bin/sim-first-boot`):

```shell
sim-first-boot core@<example IP>
ping <example IP>
# And wait for the server to come back
```

Once the server is back online, let's check the content of the `/hello` file:

```console
$ cat /hello
Hello world
```
