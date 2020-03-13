# Syzkaller [![](https://images.microbadger.com/badges/version/buszk/syzkaller-docker.svg)](https://microbadger.com/images/buszk/syzkaller-docker "Get your own version badge on microbadger.com") ![Docker](https://github.com/buszk/docker-files/workflows/syzkaller-docker/badge.svg)

## Build Image
You can build docker image for Syzkaller with our Dockerfile
```
make build 
```

## Docker Hub
The other option is to pull our image from docker hub
```
docker pull buszk/syzkaller-docker
```

## Create Container
Use the following command to start a syzkaller container. It takes a few minutes.
```
make run
```
The docker container needs to be created with `--privileged` flag. `create_image.sh` needs to run `chroot` command. We have to run this at the beginning of `docker run`.
```
docker run --privileged -it --name syzkaller syzkaller-docker
```

## Run Syzkaller
After container is correctly setup, you can start syzkaller by executing the following command.
```
bin/syz-manager --config my.cfg
```

### KVM
Make sure you enabled KVM on your system. Otherwise syzkaller will complain.

# Enjoy
