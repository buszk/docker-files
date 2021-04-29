#!/bin/bash
sudo apt-get update && \
sudo apt-get install -y  git build-essential flex bison git debootstrap \
                        libelf-dev libssl-dev bc vim sudo fakeroot ncurses-dev \
                        xz-utils protobuf-compiler python3-dev python3-pip \
                        libprotobuf-c-dev libprotoc-dev python3-protobuf g++-8 \
                        pkg-config libwiretap-dev libwireshark-dev wget curl \
                        zip protobuf-c-compiler automake software-properties-common \
                        kmod

# Fuzzer dependencies
pip3 install sysv_ipc lz4 mmh3 psutil shortuuid

# Install z3
(git clone https://github.com/Z3Prover/z3.git ~/Workspace/git/z3 && \
    cd ~/Workspace/git/z3 && \
    git checkout e63992c8bd99ce0fbc1c76575646387f8411c216 && \
    python scripts/mk_make.py && \
    cd build && \
    make -j8 && \
    sudo make install)

# Install binutils
(cd ~ && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz -O binutils-2.32.tar.gz && \
    tar xf binutils-2.32.tar.gz && \
    cd binutils-2.32 && \
    ./configure && \
    make -j 8 && \
    sudo make install)

mkdir -p ~/Workspace/git/

# Build guest linux
git clone --depth 1 https://github.com/buszk/Drifuzz.git ~/Workspace/git/Drifuzz
(cd ~/Workspace/git/Drifuzz && \
    ./compile.sh --build-linux)

# Build custom panda
git clone --depth 1 https://github.com/buszk/panda.git ~/Workspace/git/panda
(cd ~/Workspace/git/panda && \
        drifuzz/scripts/generate_filter_pc.py ~/Workspace/git/Drifuzz/linux-module-build/vmlinux && \
        panda/scripts/install_ubuntu.sh)
(cd ~/Workspace/git/Drifuzz && \
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

(cd ~/Workspace/git/Drifuzz && \
    ./compile.sh --build-image)