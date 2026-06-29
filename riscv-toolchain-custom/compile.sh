set -e

pushd riscv-gnu-toolchain
make distclean || true
./configure --prefix=$(pwd)/../_install --with-arch=rv64imac --with-abi=lp64

# The toolchain sources (riscv-gcc, riscv-glibc, ...) are embedded directly in
# this repo, NOT as git submodules. The Makefile would otherwise try to run
# `git submodule init/update` to fetch them, which fails because there is no
# parent .git/config. Pre-create the `<src>/.git` markers so make treats each
# source tree as already fetched and skips the submodule step.
for src in riscv-gcc riscv-glibc riscv-binutils riscv-gdb riscv-newlib riscv-musl; do
    [ -d "$src" ] && [ ! -e "$src/.git" ] && touch "$src/.git"
done

make linux -j$(nproc)
popd
