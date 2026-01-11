set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

KDIR=$(readlink -f "$SCRIPT_DIR/../../riscv-linux-port")

export ARCH=riscv
export CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu-
export TOOLCHAIN_PREFIX=$CROSS_COMPILE
export PATH=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin:$PATH
export TOP="$SCRIPT_DIR/umd"

cd "$SCRIPT_DIR/kmd"

make KDIR=$KDIR ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j16

cd "$SCRIPT_DIR/umd/external/protobuf-2.6"
find . -name "aclocal.m4" -exec touch {} +
find . -name "configure" -exec touch {} +
find . -name "Makefile.in" -exec touch {} +
find . -name "config.h.in" -exec touch {} +

./configure --host=riscv64-unknown-linux-gnu --disable-shared --enable-static
make -j16 -C src libprotobuf.la

cp src/.libs/libprotobuf.a "$SCRIPT_DIR/umd/core/src/compiler/libprotobuf.a"
cp src/.libs/libprotobuf.a "$SCRIPT_DIR/umd/apps/compiler/libprotobuf.a"

cd "$SCRIPT_DIR/umd"

rm -rf out/

make TOP=$TOP -j16
