#!/bin/bash
set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN_BIN="$ROOT/../riscv-toolchain-custom/_install/bin"

RISCV_CC="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-gcc"
RISCV_STRIP="$TOOLCHAIN_BIN/riscv64-unknown-linux-gnu-strip"

if [ ! -x "$RISCV_CC" ]; then
    echo "error: compiler not found at $RISCV_CC"
    exit 1
fi

BINARIES="misalign64"

echo "using $RISCV_CC"
"$RISCV_CC" --version | head -1

echo ">>> cleaning"
rm -f "$ROOT/misalign64"

# -O0: the test relies on the exact 64-bit accesses being emitted at the
# misaligned address.  Optimisation may reorder or fold them away.
# -static: the target rootfs has no shared libraries.
echo ">>> building"
"$RISCV_CC" -O0 -static -Wall -o "$ROOT/misalign64" "$ROOT/misalign64.c"
"$RISCV_STRIP" "$ROOT/misalign64"

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
