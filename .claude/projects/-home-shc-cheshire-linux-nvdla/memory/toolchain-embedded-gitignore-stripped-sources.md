---
name: toolchain-embedded-gitignore-stripped-sources
description: riscv-gnu-toolchain is embedded (not a submodule); overly-broad .gitignore patterns stripped real source files, breaking the build
metadata:
  type: project
---

The `riscv-toolchain-custom/riscv-gnu-toolchain` tree is embedded directly in the repo (intentionally NOT git submodules). Because of this, the toolchain's own build steps and gitignores cause breakages that don't happen in a normal submodule checkout:

1. **Submodule fetch fails** — the toolchain Makefile runs `git submodule init/update` to fetch each source (riscv-gcc, riscv-glibc, ...), failing with `flock: cannot open lock file .../.git/config`. Fix (in `riscv-toolchain-custom/compile.sh`): pre-create empty `<src>/.git` markers so the no-prerequisite rule `$(srcdir)/%/.git:` treats sources as already fetched.

2. **Overly-broad .gitignore patterns stripped SOURCE files** when the tree was committed/embedded (the files were never on disk in this working copy):
   - `riscv-binutils/.gitignore` had `*.info` → stripped `binutils/sysroff.info` (hand-written source, input to `sysinfo` that generates `sysroff.h`). Error: `No rule to make target 'sysroff.info'`. Fixed by adding `!sysroff.info` negation + restoring the file from upstream `riscvarchive/riscv-binutils-gdb @ riscv-binutils-2.35`.
   - `riscv-gnu-toolchain/.gitignore` had unanchored `Makefile` → stripped ALL ~202 hand-written glibc source `Makefile`s (glibc ships per-subdir Makefiles unlike gcc/binutils which use Makefile.in). Error: `No rule to make target 'all'` / `install-headers` in riscv-glibc. Fixed by anchoring to `/Makefile` + restoring missing files from upstream `riscvarchive/riscv-glibc @ riscv-glibc-2.29` (shallow clone + `rsync --ignore-existing` to add only missing files, preserving local patches).

**Why:** gcc was unaffected (uses Makefile.in). The class of bug is: any source file matching a generated-artifact ignore pattern gets silently dropped during embedding.
**How to apply:** If a future component fails with `No rule to make target '<x>'`, suspect a stripped source file — check `git check-ignore -v <path>`, fix the `.gitignore` (anchor or negate), and restore from the pinned upstream listed in `.gitmodules`. Pinned versions: binutils 2.35, gcc 10.2.0, glibc 2.29, gdb (fsf-gdb-10.1). Build is `make toolchain` → `riscv-toolchain-custom/compile.sh` → `make linux` (rv64imac/lp64), installs to `riscv-toolchain-custom/_install`.
