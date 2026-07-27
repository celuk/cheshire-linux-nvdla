OBJ = main.o fftmisc.o  fourierf.o
FILE = main.c fftmisc.c  fourierf.c
CFLAGS = -static -O3 -g

fft: ${OBJ} Makefile
	/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-gcc -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables  ${CFLAGS} ${OBJ} -o fft -lm
fftmisc.o: fftmisc.c
	/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-gcc -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables ${CFLAGS} -c fftmisc.c
fourierf.o: fourierf.c
	/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-gcc -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables ${CFLAGS} -c fourierf.c
main.o: main.c
	/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv32-unknown-linux-gnu-gcc -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables ${CFLAGS} -c main.c

clean:
	rm -rf *.o fft output*
