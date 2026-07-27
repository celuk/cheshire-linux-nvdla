---
name: toolchain-embedded-gitignore-stripped-sources
description: embedded (non-submodule) source trees in this repo had real source files stripped by overly-broad .gitignore patterns, breaking builds
metadata:
  type: project
---

The `riscv-toolchain-custom/riscv-gnu-toolchain` tree is embedded directly in the repo (intentionally NOT git submodules). Because of this, the toolchain's own build steps and gitignores cause breakages that don't happen in a normal submodule checkout:

1. **Submodule fetch fails** — the toolchain Makefile runs `git submodule init/update` to fetch each source (riscv-gcc, riscv-glibc, ...), failing with `flock: cannot open lock file .../.git/config`. Fix (in `riscv-toolchain-custom/compile.sh`): pre-create empty `<src>/.git` markers so the no-prerequisite rule `$(srcdir)/%/.git:` treats sources as already fetched.

2. **Overly-broad .gitignore patterns stripped SOURCE files** when the tree was committed/embedded (the files were never on disk in this working copy):
   - `riscv-binutils/.gitignore` had `*.info` → stripped `binutils/sysroff.info` (hand-written source, input to `sysinfo` that generates `sysroff.h`). Error: `No rule to make target 'sysroff.info'`. Fixed by adding `!sysroff.info` negation + restoring the file from upstream `riscvarchive/riscv-binutils-gdb @ riscv-binutils-2.35`.
   - `riscv-gnu-toolchain/.gitignore` had unanchored `Makefile` → stripped ALL ~202 hand-written glibc source `Makefile`s (glibc ships per-subdir Makefiles unlike gcc/binutils which use Makefile.in). Error: `No rule to make target 'all'` / `install-headers` in riscv-glibc. Fixed by anchoring to `/Makefile` + restoring missing files from upstream `riscvarchive/riscv-glibc @ riscv-glibc-2.29` (shallow clone + `rsync --ignore-existing` to add only missing files, preserving local patches).

3. **Same bug outside the toolchain — busybox:** `riscv-busybox-port/.gitignore` had unanchored `Config.in` → stripped the top-level `Config.in` (hand-written master kconfig; the per-subdir `*/Config.in` are generated from `Config.src` by `scripts/gen_build_files.sh` and are correctly ignored). Error: `can't find file Config.in` during `make defconfig`. Fixed by adding `!/Config.in` negation + restoring the file from busybox 1.36.1 (`raw.githubusercontent.com/mirror/busybox/1_36_1/Config.in`).

**Other `make all` fixes (2026-06-29):**
- `riscv-busybox-port/compile.sh` no longer needs sudo: device nodes (`/dev/console`, `/dev/null`) are now baked into `rootfs.cpio` via the kernel's `usr/gen_init_cpio` + `usr/gen_initramfs.sh -u 0 -g 0` (text spec `devnodes.list`), instead of `sudo mknod`. `cc` builds gen_init_cpio on demand since busybox runs before the kernel in `make all`.
- `riscv-linux-port/arch/riscv/configs/64-bit.config` `CONFIG_INITRAMFS_SOURCE` was a stale absolute path (`/home/shc/projects/...` — `projects/` dir doesn't exist here). Changed to relative `../riscv-busybox-port/rootfs.cpio` (kernel builds in-tree, resolves relative to its top dir).

**Why:** gcc was unaffected (uses Makefile.in). The class of bug is: any source file matching a generated-artifact ignore pattern gets silently dropped during embedding.
**How to apply:** If a future component fails with `No rule to make target '<x>'`, suspect a stripped source file — check `git check-ignore -v <path>`, fix the `.gitignore` (anchor or negate), and restore from the pinned upstream listed in `.gitmodules`. Pinned versions: binutils 2.35, gcc 10.2.0, glibc 2.29, gdb (fsf-gdb-10.1). Build is `make toolchain` → `riscv-toolchain-custom/compile.sh` → `make linux` (rv64imac/lp64), installs to `riscv-toolchain-custom/_install`.
