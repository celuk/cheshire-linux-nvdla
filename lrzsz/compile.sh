set -e

autoconf
TOOLCHAIN="$(cd ../riscv-toolchain-custom/_install/bin && pwd)"
CC="$TOOLCHAIN/riscv64-unknown-linux-gnu-gcc" CXX="$TOOLCHAIN/riscv64-unknown-linux-gnu-g++" LDFLAGS="-static" ./configure --host=riscv64
make LDFLAGS="-all-static"
cp src/lsz .
cp src/lrz .
cp lrz rz
cp lsz sz
