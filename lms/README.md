LMS
===

RFC 8554 LMS/HSS hash-based signatures (Cisco hash-sigs with SHA-3 added),
built static for rv64imac RISC-V Linux. Uses the internal SHA-256 and the
Brainhub SHA-3, so no OpenSSL is needed (`USE_OPENSSL 0` in `sha256.h`).

Build
-----

    ./compile.sh

Produces `demo` (pthread, 16 threads) and `demo_st` (single thread).

Run on the target
-----------------

    ./demo_st genkey mykey sha2/5/1
    ./demo_st sign mykey lipsum
    ./demo_st verify mykey lipsum

Parameter set syntax is `[sha2|sha3]/height/winternitz[,next tree][:aux bytes]`,
height 5/10/15/20, winternitz 1/2/4/8. Without a parameter set the default is
`20/8,10/8`, which takes minutes on x86 and far longer on CVA6 - use a small
height. `lipsum` is a sample file to sign; `sign` writes `lipsum.sig` and
updates `mykey.prv`.
