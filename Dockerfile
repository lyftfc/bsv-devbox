FROM ubuntu:24.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install requisites
RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    curl \
    wget \
    sudo \
    vim \
    xz-utils \
    python3 \
    python3-pip \
    build-essential \
    cmake \
    ninja-build \
    iverilog \
    verilator \
    gtkwave \
    && rm -rf /var/lib/apt/lists/*

# Allow the 'ubuntu' user to use sudo without a password
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

# Installing Bluespec Compiler (bsc) and extra libraries
RUN wget -O /tmp/bsc-2025.07-ubuntu-24.04.tar.gz https://github.com/B-Lang-org/bsc/releases/download/2025.07/bsc-2025.07-ubuntu-24.04.tar.gz \
    && tar xzf /tmp/bsc-2025.07-ubuntu-24.04.tar.gz -C /opt \
    && mv /opt/bsc-* /opt/bluespec \
    && rm /tmp/bsc-2025.07-ubuntu-24.04.tar.gz

ENV PATH=/opt/bluespec/bin:$PATH

# Installing extra Bluespec libraries from provided archive
COPY bsc25-lib-extra.txz /tmp/bsc25-lib-extra.txz

RUN mkdir -p /opt/bluespec/lib/Libraries \
    && tar xJf /tmp/bsc25-lib-extra.txz -C /tmp \
    && cp -a /tmp/bsc25-lib-extra/. /opt/bluespec/lib/Libraries/ \
    && rm -rf /tmp/bsc25-lib-extra /tmp/bsc25-lib-extra.txz

# Installing Cocotb container-wide under root
RUN pip3 install --break-system-packages cocotbext-axi==0.1.24 cocotb==1.9.2

# Patching Cocotb Makefile to fix Bluespec-generated Verilog files compatibility
# This patch is created with: diff -u Makefile.verilator Makefile.verilator.patched > <patchfile>
COPY bsc-verilator-cocotb-1-9-2.patch /tmp/bsc-verilator-cocotb-1-9-2.patch

RUN cd /usr/local/lib/python3.12/dist-packages/cocotb/share/makefiles/simulators \
    && patch Makefile.verilator < /tmp/bsc-verilator-cocotb-1-9-2.patch \
    && rm /tmp/bsc-verilator-cocotb-1-9-2.patch

