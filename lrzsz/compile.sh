set -e

autoconf
CC=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install2/bin/riscv64-unknown-linux-gnu-gcc CXX=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install2/bin/riscv64-unknown-linux-gnu-g++ LDFLAGS="-static" ./configure --host=riscv64
make LDFLAGS="-all-static"
cp src/lsz .
cp src/lrz .
cp lrz rz
cp lsz sz
