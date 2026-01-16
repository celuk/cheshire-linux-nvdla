SHELL := /bin/bash
.PHONY: all opensbi lrzsz nvdla busybox linux

all: opensbi lrzsz busybox linux nvdla busybox linux

opensbi:
	pushd riscv-opensbi-port && ./compile.sh && popd

busybox:
	pushd riscv-busybox-port && ./compile.sh && popd

linux:
	pushd riscv-linux-port && ./compile.sh && popd

lrzsz:
	pushd lrzsz && ./compile.sh && popd

nvdla:
	pushd nvdla/sw && ./compile.sh && popd
