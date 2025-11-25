# BSV Development Container

Docker container based on Ubuntu image, packed with tools required for Bluespec development.

The [Bluespec Compiler (BSC)](https://github.com/B-Lang-org/bsc) is installed to `/opt/bluespec`.
The BSC [contributed library](https://github.com/B-Lang-org/bsc-contrib) is also built and patched to the library, along with extra utilities from the [Flute](https://github.com/bluespec/Flute) processor repository, for AXI4 Streams and simulation cycle utilities.

It also packs Icarus Verilog, Verilator and Cocotb for design simulation and verification. Cocotb Makefile for Verilator is patched for BSC-generated code quirks.

## Usage

The image is pre-built on Docker hub: https://hub.docker.com/r/lyftfc/bsv-devbox

Currently we build it from an x86_64 Linux machine.

To build it yourself, simply do
`docker build -t <image_name> .`
in this repository.

This image is intended to be used as a VS Code devcontainer base.
The pre-packed image saves package installation time; however, you
can always reuse the image to create devcontainer yourself.
Refer to [this link](https://containers.dev/guide/dockerfile) for more information.

## Versions

The current version `v24.1` is based on the official Ubuntu 24.04 image.

Tools:
- Bluespec Compiler (BSC) `2025.07` — installed to `/opt/bluespec`
- Icarus Verilog (iverilog) — RTL simulation tool
- Verilator `5.020` — cycle-accurate HDL simulator
- Cocotb `1.9.2` — Python-based co‑simulation/testbench framework
- GCC C++ Compiler `13.3.0`
- CMake `3.28.3`
- Python `3.12.3`
