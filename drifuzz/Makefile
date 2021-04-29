all: build run

build: Dockerfile
	docker build . -t drifuzz-first
	docker rm drifuzz-intermediate || true
	docker run --privileged --name drifuzz-intermediate drifuzz-first /bin/bash -c "bash /root/build_previleged.sh"
	docker commit --change "CMD /bin/bash" drifuzz-intermediate drifuzz-image

run: build
	docker run -it --rm --privileged drifuzz-image
	
