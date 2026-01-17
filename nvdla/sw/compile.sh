set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

KDIR=$(readlink -f "$SCRIPT_DIR/../../riscv-linux-port")

export ARCH=riscv
export CROSS_COMPILE=$(pwd)/../../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-
export TOOLCHAIN_PREFIX=$CROSS_COMPILE
export PATH=$(pwd)/../../riscv-toolchain-custom/_install/bin:$PATH
export TOP="$SCRIPT_DIR/umd"

# Define DLA_2_CONFIG globally
export KCFLAGS="-DDLA_2_CONFIG"
export CFLAGS="-DDLA_2_CONFIG"
export CXXFLAGS="-DDLA_2_CONFIG"

cd "$SCRIPT_DIR/kmd"
make clean
make KDIR=$KDIR ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE CFLAGS+="-DDLA_2_CONFIG" CXXFLAGS+="-DDLA_2_CONFIG" -j16

cd "$SCRIPT_DIR"
if [ ! -d "umd/external/libjpeg-turbo-1.5.3" ]; then
    echo "Downloading libjpeg-turbo..."
    wget -q https://sourceforge.net/projects/libjpeg-turbo/files/1.5.3/libjpeg-turbo-1.5.3.tar.gz
    tar xzf libjpeg-turbo-1.5.3.tar.gz -C umd/external/
    rm libjpeg-turbo-1.5.3.tar.gz
fi

cd "$SCRIPT_DIR/umd/external/libjpeg-turbo-1.5.3"

if [ ! -f "Makefile" ]; then
    ./configure --host=riscv64-unknown-linux-gnu --disable-shared --enable-static
else
    make clean
fi
make -j16
cp .libs/libjpeg.a "$SCRIPT_DIR/umd/external/libjpeg.a"

cd "$SCRIPT_DIR/umd/external/protobuf-2.6"
find . -name "aclocal.m4" -exec touch {} +
find . -name "configure" -exec touch {} +
find . -name "Makefile.in" -exec touch {} +
find . -name "config.h.in" -exec touch {} +

if [ ! -f "Makefile" ]; then
    ./configure --host=riscv64-unknown-linux-gnu --disable-shared --enable-static
else
    make distclean
fi
make -j16 -C src libprotobuf.la

cp src/.libs/libprotobuf.a "$SCRIPT_DIR/umd/core/src/compiler/libprotobuf.a"
cp src/.libs/libprotobuf.a "$SCRIPT_DIR/umd/apps/compiler/libprotobuf.a"

cd "$SCRIPT_DIR/umd"
make clean
rm -rf out/

make TOP=$TOP -j16 compiler runtime CFLAGS+="-DDLA_2_CONFIG" CXXFLAGS+="-DDLA_2_CONFIG"
