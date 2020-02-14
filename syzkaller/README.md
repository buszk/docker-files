# Syzkaller

## Build Image
You can build docker image for Syzkaller with our Dockerfile
```
docker build . -t syzkaller-docker
```

## Docker Hub
The other option is to pull our image from docker hub
```
docker pull buszk/syzkaller-docker
```

## Create Container
The docker container needs to be created by the following command. `--privileged` flag may be needed for chroot command if you want to create image. 
```
docker run --privileged -it --name syzkaller syzkaller-docker
```

# Enjoy