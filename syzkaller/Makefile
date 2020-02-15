all: build run

build: Dockerfile
	docker build . -t syzkaller-docker

run: build
	docker run -it --rm --privileged --expose 56741 syzkaller-docker
