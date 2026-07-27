RISCV_CC ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-gcc

rijndael: aes.c aes.h aestab.h aesxam.c Makefile
	$(RISCV_CC) -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -static -O3 -o rijndael aes.c aesxam.c

clean:
	rm -rf rijndael output*
