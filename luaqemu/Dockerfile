# The file is borrowed and slightly modified from bsw4p 's PR to luaqemu project
# https://github.com/Comsecuris/luaqemu/blob/cb70f9215cba6e975927919a27e93ff633f31f59/Dockerfile

FROM debian:jessie

RUN apt-get update && apt-get install -y make gcc g++ wget python unzip bc \
    automake cpio bison flex texinfo binutils build-essential gzip locales \
    mercurial patch perl sed tar git strace pkg-config zlib1g-dev \
    libglib2.0-dev libpixman-1-dev libfdt-dev git-email libaio-dev \
    libbluetooth-dev libbrlapi-dev libbz2-dev libcap-dev libcap-ng-dev \
    libcurl4-gnutls-dev libgtk-3-dev libibverbs-dev libjpeg-dev \
    libncurses5-dev libnuma-dev librbd-dev librdmacm-dev \
    libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev \ 
    libvde-dev libvdeplug-dev libvte-2.91-dev libxen-dev liblzo2-dev \
    valgrind xfslibs-dev luajit libluajit-5.1-dev vim 

RUN git clone https://github.com/Comsecuris/luaqemu --depth=1

WORKDIR luaqemu 

RUN git submodule update --init dtc

RUN ./configure --enable-luajit --target-list=arm-softmmu && make -j4
