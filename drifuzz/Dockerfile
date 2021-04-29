FROM ubuntu:18.04
LABEL maintainer="Zekun Shen bruceshenzk@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf8
RUN apt-get update && \
    apt-get install -y  git build-essential flex bison git debootstrap libz3-dev\
                        libelf-dev libssl-dev bc vim sudo fakeroot ncurses-dev \
                        xz-utils protobuf-compiler python3-dev python3-pip \
                        libprotobuf-c-dev libprotoc-dev python3-protobuf g++-8 \
                        pkg-config libwiretap-dev libwireshark-dev wget \
                        zip protobuf-c-compiler automake software-properties-common \
                        kmod

RUN (pip3 install sysv_ipc lz4 mmh3 psutil)

RUN mkdir -p ~/Workspace/git/

RUN git clone --depth 1 https://github.com/buszk/Drifuzz.git ~/Workspace/git/Drifuzz

RUN (cd ~/Workspace/git/Drifuzz && \
    ./compile.sh --build-linux)

RUN (cd ~/Workspace && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz -O binutils-2.32.tar.gz && \
    tar xf binutils-2.32.tar.gz && \
    cd binutils-2.32 && \
    ./configure && \
    make -j 8 && \
    make install)
RUN git clone --depth 1 https://github.com/buszk/panda.git ~/Workspace/git/panda
RUN (cd ~/Workspace/git/panda && \
        drifuzz/scripts/generate_filter_pc.py ~/Workspace/git/Drifuzz/linux-module-build/vmlinux)
RUN (cd ~/Workspace/git/panda && \
        panda/scripts/install_ubuntu.sh)
RUN (git clone https://github.com/Z3Prover/z3.git ~/Workspace/git/z3 && \
    cd ~/Workspace/git/z3 && \
    git log && \
    git checkout e63992c8bd99ce0fbc1c76575646387f8411c216 && \
    python scripts/mk_make.py && \
    cd build && \
    make -j8 && \
    sudo make install)
RUN (cd ~/Workspace/git/Drifuzz && \
    rm -rf panda-build && \
    mkdir panda-build && \
    cd panda-build && \
    ../panda/configure \
        --target-list=x86_64-softmmu \
        --cc=gcc-8 --cxx=g++-8 \
        --enable-llvm --with-llvm=$(llvm-config-3.3 --prefix) \
        --extra-cxxflags=-Wno-error=class-memaccess \
        --disable-werror \
        --python=python3 && \
    make -j 8)

COPY build_previleged.sh /root/build_previleged.sh
    
