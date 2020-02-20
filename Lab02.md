# Lab 02 - Hello Container Linux

## Goals

- Verify that your Container Linux machines are up and running
- Deploy and desotry a simple application

## Verify your container Linux machines

To verify that your machines are up and running we're going to deploy Nginx and validate that it works OK.

```shell
docker run -d -p 80:80 --name nginx nginx
docker ps
curl localhost
```

You'll notice that Container Linux ships with Docker built-in.

## Container information

Use the following commands to gather information about the nginx container we just created:

```shell
docker inspect nginx | jq
docker stats
```

Use `ctrl+c` to exit

## Tear down

```shell
docker rm -f nginx
```

Verify that the container are deleted with `docker ps`.

## Next Steps

Once you're done, proceed to [Lab03](Lab03.md)
