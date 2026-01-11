set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

KDIR=$(readlink -f "$SCRIPT_DIR/../../riscv-linux-port")

export ARCH=riscv
export CROSS_COMPILE=/media/shc/0EDEBC4906059163/tools/riscv-toolchain-linux/_install/bin/riscv64-unknown-linux-gnu-

cd "$SCRIPT_DIR/kmd"

make KDIR=$KDIR ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j16
