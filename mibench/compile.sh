#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN_BIN="$ROOT/../riscv-toolchain-custom/_install/bin"

export RISCV_CC="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-gcc"
export RISCV_STRIP="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-strip"

if [ ! -x "$RISCV_CC" ]; then
    echo "error: compiler not found at $RISCV_CC"
    exit 1
fi

BENCHMARKS="automotive/basicmath office/stringsearch network/dijkstra security/sha security/rijndael"

BINARIES="automotive/basicmath/basicmath_small
automotive/basicmath/basicmath_large
office/stringsearch/search_small
office/stringsearch/search_large
network/dijkstra/dijkstra_small
network/dijkstra/dijkstra_large
security/sha/sha
security/rijndael/rijndael"

echo "using $RISCV_CC"
"$RISCV_CC" --version | head -1

for bench in $BENCHMARKS; do
    echo ">>> cleaning $bench"
    make -C "$ROOT/$bench" clean
done

for bench in $BENCHMARKS; do
    echo ">>> building $bench"
    make -C "$ROOT/$bench" -j"$(nproc)"
done

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
