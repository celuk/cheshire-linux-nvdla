RISCV_CC ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-gcc

all:  dijkstra_large dijkstra_small

dijkstra_large: dijkstra_large.c Makefile
	$(RISCV_CC) -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -static dijkstra_large.c -O3 -o dijkstra_large

dijkstra_small: dijkstra_small.c Makefile
	$(RISCV_CC) -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -static dijkstra_small.c -O3 -o dijkstra_small

clean:
	rm -rf dijkstra_large dijkstra_small output*
