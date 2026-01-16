set -e

make clean;
make mrproper;
make distclean;
make ARCH=riscv CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu- 64-bit.config;
make ARCH=riscv CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu- -j16;
/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu-objdump -m riscv:rv64 -d vmlinux > vmlinux.dump;
## Image = vmlinux.bin
#dd if=/dev/zero bs=1 count=4096 >> ./arch/riscv/boot/Image
python3 /home/shc/projects/cva-soc/tools/bin2hex.py ./arch/riscv/boot/Image > ./arch/riscv/boot/Image.hex;
#/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu-objcopy -O binary ./vmlinux vmlinux.bin
#python3 /home/shc/projects/cva-soc/tools/bin2hex.py ./vmlinux.bin > ./vmlinux.hex;
/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu-objcopy -O verilog ./vmlinux ./vmlinux.vmem;
