FROM ubuntu:18.04
LABEL maintainer="Zekun Shen bruceshenzk@gmail.com"

ENV GCC /usr
ENV KERNEL /kernel 
ENV IMAGE /image

RUN apt-get update && \
    apt-get -y install golang-go vim subversion build-essential flex bison libc6-dev libc6-dev-i386 \
                       linux-libc-dev libgmp3-dev libmpfr-dev libmpc-dev git debootstrap qemu-kvm \
                       libelf-dev libssl-dev bc qemu debootstrap sudo

RUN git clone --depth 1 https://github.com/torvalds/linux.git /kernel

RUN ( cd /kernel      && \
    make defconfig   && \
    make kvmconfig   && \
    echo -e "CONFIG_KCOV=y\nCONFIG_DEBUG_INFO=y\nCONFIG_KASAN=y\nCONFIG_KASAN_INLINE=y\nCONFIG_CONFIGFS_FS=y\nCONFIG_SECURITYFS=y\n" >> .config && \
    make CC=/usr/bin/gcc oldconfig && \
    make CC=/usr/bin/gcc -j4 && \
    test -f /kernel/vmlinux && \
    test -f /kernel/arch/x86/boot/bzImage )

RUN mkdir -p /image && \
    ( cd /image && \
    wget https://raw.githubusercontent.com/google/syzkaller/master/tools/create-image.sh -O create-image.sh )

RUN go get -u -d github.com/google/syzkaller/... 

RUN ( cd $HOME/go/src/github.com/google/syzkaller && NCORE=4 make )

WORKDIR /root/go/src/github.com/google/syzkaller

COPY my.cfg .

CMD ( cd /image && bash /image/create-image.sh ) && \
    /bin/bash 