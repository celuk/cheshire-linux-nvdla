#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN_BIN="$ROOT/../riscv-toolchain-custom/_install/bin"

export RISCV_CC="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-gcc"
export RISCV_AR="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-ar"
export RISCV_STRIP="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-strip"

if [ ! -x "$RISCV_CC" ]; then
    echo "error: compiler not found at $RISCV_CC"
    exit 1
fi

BINARIES="demo_st demo"

echo "using $RISCV_CC"
"$RISCV_CC" --version | head -1

echo ">>> cleaning"
make -C "$ROOT" clean

echo ">>> building"
make -C "$ROOT" -j"$(nproc)"

echo ">>> results"
STATUS=0
for bin in $BINARIES; do
    if [ -f "$ROOT/$bin" ]; then
        echo "  ok   $bin"
    else
        echo "  FAIL $bin"
        STATUS=1
    fi
done

exit $STATUS
