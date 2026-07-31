SHELL := /bin/bash
.PHONY: all mibench lms wonvdla opensbi lrzsz opencv tengine nvdla busybox linux toolchain

all: opensbi lrzsz busybox linux nvdla busybox linux

mibench:
	pushd mibench && ./compile.sh && popd

lms:
	pushd lms && ./compile.sh && popd

wonvdla: opensbi lrzsz busybox linux

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

opencv:
	pushd opencv && ./compile.sh && popd

tengine:
	pushd tengine && ./compile.sh && popd

toolchain:
	pushd riscv-toolchain-custom && ./compile.sh && popd
