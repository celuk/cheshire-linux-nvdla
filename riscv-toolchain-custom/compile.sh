set -e

pushd riscv-gnu-toolchain
make distclean || true
./configure --prefix=$(pwd)/../_install --with-arch=rv64imac --with-abi=lp64

# Sources are embedded, not submodules: fake the .git markers so the Makefile skips submodule fetch.
for src in riscv-gcc riscv-glibc riscv-binutils riscv-gdb riscv-newlib riscv-musl; do
    [ -d "$src" ] && [ ! -e "$src/.git" ] && touch "$src/.git"
done

make linux -j$(nproc)
popd
