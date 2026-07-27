# By default, the code is compiled for a "big endian" machine.
# To compile on a "little endian" machine set the LITTLE_ENDIAN flag.
# To make smaller object code, but run a little slower, don't use UNROLL_LOOPS.
# To use NIST's modified SHA of 7/11/94, define USE_MODIFIED_SHA

RISCV_CC ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-gcc
RISCV_STRIP ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-strip

CC = $(RISCV_CC) -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables
CFLAGS = -O3 -Wall

sha:	sha_driver.o sha.o
	$(CC) -static -o $@ sha_driver.o sha.o
	$(RISCV_STRIP) $@

clean:
	rm -rf *.o sha output*
