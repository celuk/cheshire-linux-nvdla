set -e

pushd riscv-gnu-toolchain
make distclean
./configure --prefix=$(pwd)/../_install
make linux -j16
popd
