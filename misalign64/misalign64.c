/*
 * misalign64 -- check whether this platform handles misaligned 64-bit
 * load/store correctly.
 *
 * Background: CVA6 raises LD/ST_ADDR_MISALIGNED for a 64-bit access whose
 * address is not 8-byte aligned, and OpenSBI emulates it byte-wise in M-mode.
 * If that exception never fires, the LSU performs a single aligned doubleword
 * access with the data byte-rotated instead, so bytes that should land in the
 * next doubleword wrap around to the start of the current one -- silently
 * corrupting data with no trap.
 *
 * That is what broke nvdla_runtime: emu_address::hMem is a 64-bit pointer at
 * a 4-mod-8 offset inside packed emu_task_desc, so a mapped VA lost its top
 * 32 bits and Emulator::processTask faulted dereferencing it.
 *
 * Run this after any RTL or firmware change to the misaligned path. All four
 * result lines must say OK.
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <sys/syscall.h>

#ifndef PR_GET_UNALIGN
#define PR_GET_UNALIGN 5
#endif

#define NR_riscv_hwprobe 258
#define HWPROBE_KEY_MISALIGNED_SCALAR_PERF 9

struct riscv_hwprobe {
    int64_t  key;
    uint64_t value;
};

static const char *scalar_perf[] = {
    "UNKNOWN   (no misaligned trap reached Linux: M-mode or hardware handles them)",
    "EMULATED  (Linux emulates them: misaligned load/store are delegated)",
    "SLOW      (hardware handles them)",
    "FAST      (hardware handles them)",
    "UNSUPPORTED",
};

static void who_handles_misaligned(void)
{
    struct riscv_hwprobe pair = {HWPROBE_KEY_MISALIGNED_SCALAR_PERF, 0};
    int val;

    printf("== who handles misaligned accesses ==\n");

    if (syscall(NR_riscv_hwprobe, &pair, 1UL, 0UL, NULL, 0UL) == 0)
        printf("  hwprobe MISALIGNED_SCALAR_PERF = %llu  %s\n",
               (unsigned long long)pair.value,
               pair.value < 5 ? scalar_perf[pair.value] : "?");
    else
        printf("  hwprobe failed: %s\n", strerror(errno));

    /*
     * prctl(PR_GET_UNALIGN) only succeeds when the kernel decided at boot that
     * it emulates misaligned accesses (unaligned_ctl_available()).  EINVAL
     * means the traps never reached S-mode.
     */
    errno = 0;
    if (prctl(PR_GET_UNALIGN, &val) == 0)
        printf("  prctl(PR_GET_UNALIGN) = 0 (val=%d) -> Linux owns misaligned traps\n", val);
    else
        printf("  prctl(PR_GET_UNALIGN) failed (%s) -> Linux does NOT own misaligned traps\n",
               strerror(errno));
    printf("\n");
}

static void dump(const char *tag, const unsigned char *b, int n)
{
    printf("    %-14s", tag);
    for (int i = 0; i < n; i++)
        printf(" %02x", b[i]);
    printf("\n");
}

int main(void)
{
    unsigned char *buf = malloc(64);
    const uint64_t want = 0x0000003f9bcca000ULL; /* shaped like a real mapped VA */
    volatile uint64_t *p;
    uint64_t got, in_mem;
    int bad = 0;

    if (!buf) {
        fprintf(stderr, "malloc failed\n");
        return 2;
    }

    who_handles_misaligned();

    printf("== misaligned 64-bit access ==\n");
    printf("  buf = %p   want = %016llx\n\n", (void *)buf, (unsigned long long)want);

    /* control: naturally aligned */
    memset(buf, 0, 64);
    p = (volatile uint64_t *)(buf + 8);
    *p = want;
    got = *p;
    printf("  aligned   +8 : got %016llx  %s\n", (unsigned long long)got,
           got == want ? "OK" : "BROKEN");
    if (got != want)
        bad = 1;

    /* the NVDLA case: 64-bit store then 64-bit load at 4 mod 8 */
    memset(buf, 0, 64);
    p = (volatile uint64_t *)(buf + 4);
    *p = want;
    got = *p;
    printf("  misaligned+4 : got %016llx  %s\n", (unsigned long long)got,
           got == want ? "OK" : "BROKEN");
    dump("bytes +0..15:", buf, 16);
    if (got != want)
        bad = 1;

    /* store misaligned, read back byte-wise -> did the store lose bytes? */
    memset(buf, 0, 64);
    p = (volatile uint64_t *)(buf + 4);
    *p = want;
    memcpy(&in_mem, buf + 4, 8);
    printf("  store only   : mem %016llx  %s\n", (unsigned long long)in_mem,
           in_mem == want ? "OK" : "STORE TRUNCATED");
    if (in_mem != want)
        bad = 1;

    /* write byte-wise, read with a misaligned load -> did the load lose bytes? */
    memset(buf, 0, 64);
    memcpy(buf + 4, &want, 8);
    p = (volatile uint64_t *)(buf + 4);
    got = *p;
    printf("  load only    : got %016llx  %s\n", (unsigned long long)got,
           got == want ? "OK" : "LOAD TRUNCATED");
    if (got != want)
        bad = 1;

    free(buf);

    printf("\n%s\n", bad ? "=> misaligned 64-bit access is BROKEN on this platform"
                         : "=> misaligned 64-bit access round-trips correctly");
    return bad;
}
