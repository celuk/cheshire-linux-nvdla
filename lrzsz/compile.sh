set -e

autoconf
CC=../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-gcc CXX=../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-g++ LDFLAGS="-static" ./configure --host=riscv64
make LDFLAGS="-all-static"
cp src/lsz .
cp src/lrz .
cp lrz rz
cp lsz sz
