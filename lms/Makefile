RISCV_CC ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-gcc
RISCV_AR ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-ar
RISCV_STRIP ?= /home/shc/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-strip

CC = $(RISCV_CC)
AR = $(RISCV_AR)
CFLAGS = -march=rv64imac -mabi=lp64 -O3 -Wall -DRISCV=1 \
         -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables
LDFLAGS = -static

CORE_SRC = hss.c hss_alloc.c hss_aux.c hss_common.c hss_compute.c hss_generate.c \
           hss_keygen.c hss_param.c hss_reserve.c hss_sign.c hss_sign_inc.c \
           hss_verify.c hss_verify_inc.c hss_derive.c hss_zeroize.c \
           lm_common.c lm_ots_common.c lm_ots_sign.c lm_ots_verify.c lm_verify.c \
           endian.c hash.c sha256.c ossl_sha3.c ossl_keccak1600.c bh_sha3.c

VERIFY_SRC = hss_verify.c hss_verify_inc.c hss_common.c hss_zeroize.c \
             lm_common.c lm_ots_common.c lm_ots_verify.c lm_verify.c \
             endian.c hash.c sha256.c ossl_sha3.c ossl_keccak1600.c bh_sha3.c

CORE_OBJ = $(CORE_SRC:.c=.o)
VERIFY_OBJ = $(VERIFY_SRC:.c=.o)

all: demo_st demo

hss_lib.a: $(CORE_OBJ) hss_thread_single.o
	$(AR) rcs $@ $^

hss_lib_thread.a: $(CORE_OBJ) hss_thread_pthread.o
	$(AR) rcs $@ $^

hss_verify.a: $(VERIFY_OBJ) hss_thread_single.o
	$(AR) rcs $@ $^

demo_st: demo.c hss_lib.a
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ demo.c hss_lib.a
	$(RISCV_STRIP) $@

demo: demo.c hss_lib_thread.a
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ demo.c hss_lib_thread.a -lpthread
	$(RISCV_STRIP) $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.a demo demo_st *.prv *.pub *.aux *.sig

.PHONY: all clean
