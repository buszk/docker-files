#!/bin/bash
sudo apt-get update && \
sudo apt-get install -y build-essential flex bison git debootstrap genisoimage \
                        libelf-dev libssl-dev bc vim sudo fakeroot ncurses-dev \
                        xz-utils protobuf-compiler python3-dev python3-pip kmod \
                        libprotobuf-c-dev libprotoc-dev python3-protobuf g++-8 \
                        pkg-config libwiretap-dev libwireshark-dev wget curl \
                        zip protobuf-c-compiler automake software-properties-common

# Fuzzer and concolic dependencies
pip3 install sysv_ipc lz4 mmh3 psutil shortuuid tempdir pexpect intervaltree

NP=$(nproc)
# Install z3
(git clone https://github.com/Z3Prover/z3.git ~/Workspace/git/z3 && \
    cd ~/Workspace/git/z3 && \
    git checkout e63992c8bd99ce0fbc1c76575646387f8411c216 && \
    python scripts/mk_make.py && \
    cd build && \
    make -j $NP && \
    sudo make install)

# Install binutils (needs objdump-2.32)
(cd ~ && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.32.tar.gz -O binutils-2.32.tar.gz && \
    tar xf binutils-2.32.tar.gz && \
    cd binutils-2.32 && \
    ./configure && \
    make -j $NP && \
    sudo make install)

mkdir -p ~/Workspace/git/

# Build guest linux
git clone --depth 1 https://github.com/buszk/Drifuzz.git ~/Workspace/git/Drifuzz
(cd ~/Workspace/git/Drifuzz && \
    ./compile.sh --build-linux -j $NP)

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
    make -j $NP)

# Build a boot image
(cd ~/Workspace/git/Drifuzz && \
    ./compile.sh --build-image)

# Prepare drifuzz-concolic
git clone --depth 1 https://github.com/buszk/drifuzz-concolic.git ~/Workspace/git/drifuzz-concolic
git clone --depth 1 https://github.com/buszk/drifuzz-model-result ~/Workspace/git/drifuzz-model-result
cp -r ~/Workspace/git/drifuzz-model-result ~/Workspace/git/drifuzz-concolic/work
rm -rf ~/Workspace/git/drifuzz-concolic/work/.git
