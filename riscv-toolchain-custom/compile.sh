set -e

pushd riscv-gnu-toolchain
make distclean
./configure --prefix=$(pwd)/../_install --with-arch=rv64imac --with-abi=lp64
make linux -j16
popd
