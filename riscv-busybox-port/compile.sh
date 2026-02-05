#!/bin/bash

sudo rm -rf ./_install ./rootfs.cpio.gz;
make distclean;
make defconfig;
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config;
export CROSS_COMPILE=../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-;
make -j14;
make install;


BENCH=6

if [ "$BENCH" = "1" ]; then
cp "/home/shc/projects/mibench2/automotive/basicmath/basicmath_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/basicmath_small;
cp "/home/shc/projects/mibench2/automotive/basicmath/runme_small.sh" ./_install;
fi

if [ "$BENCH" = "2" ]; then
cp "/home/shc/projects/mibench2/network/dijkstra/dijkstra_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/dijkstra_small;
cp "/home/shc/projects/mibench2/network/dijkstra/input.dat" ./_install;
fi

if [ "$BENCH" = "3" ]; then
cp "/home/shc/projects/mibench2/office/stringsearch/search_small" ./_install;
"${CROSS_COMPILE}strip" ./_install/search_small;
fi

if [ "$BENCH" = "4" ]; then
cp "/home/shc/projects/mibench2/security/rijndael/rijndael" ./_install;
"${CROSS_COMPILE}strip" ./_install/rijndael;
cp "/home/shc/projects/mibench2/security/rijndael/input_small.asc" ./_install;
fi

if [ "$BENCH" = "5" ]; then
cp "/home/shc/projects/mibench2/security/sha/sha" ./_install;
"${CROSS_COMPILE}strip" ./_install/sha;
cp "/home/shc/projects/mibench2/security/sha/input_small.asc" ./_install;
fi

if [ "$BENCH" = "6" ]; then
cp "/home/shc/projects/mibench2/telecomm/FFT/fft" ./_install;
"${CROSS_COMPILE}strip" ./_install/fft;
fi

if [ "$BENCH" = "7" ]; then
cp "/home/shc/projects/mibench2/consumer/jpeg/jpeg-6a/cjpeg" ./_install;
cp "/home/shc/projects/mibench2/consumer/jpeg/jpeg-6a/djpeg" ./_install;
"${CROSS_COMPILE}strip" ./_install/cjpeg;
"${CROSS_COMPILE}strip" ./_install/djpeg;
cp "/home/shc/projects/mibench2/consumer/jpeg/input_small.ppm" ./_install;
cp "/home/shc/projects/mibench2/consumer/jpeg/input_small.jpg" ./_install;
fi

# Copy lrzsz binaries if they exist
if [ -f "../lrzsz/rz" ] && [ -f "../lrzsz/sz" ]; then
    echo "Copying lrzsz binaries..."
    cp ../lrzsz/rz ./_install/bin/rz
    cp ../lrzsz/sz ./_install/bin/sz
    chmod +x ./_install/bin/rz ./_install/bin/sz
    echo "Stripping lrzsz binaries..."
    "${CROSS_COMPILE}strip" ./_install/bin/rz ./_install/bin/sz
else
    echo "Warning: lrzsz binaries not found at ../lrzsz/"
fi

# Copy opendla.ko
if [ -f "../nvdla/sw/kmd/port/linux/opendla.ko" ]; then
    echo "Copying opendla.ko..."
    cp "../nvdla/sw/kmd/port/linux/opendla.ko" ./_install/opendla.ko
    echo "Stripping opendla.ko..."
    "${CROSS_COMPILE}strip" --strip-debug ./_install/opendla.ko
else
    echo "Warning: opendla.ko not found at ../nvdla/sw/kmd/port/linux/"
fi

# Copy nvdla_runtime
if [ -f "../nvdla/sw/umd/out/apps/runtime/nvdla_runtime/nvdla_runtime" ]; then
    echo "Copying nvdla_runtime..."
    cp "../nvdla/sw/umd/out/apps/runtime/nvdla_runtime/nvdla_runtime" ./_install/bin/nvdla_runtime
    chmod +x ./_install/bin/nvdla_runtime
    echo "Stripping nvdla_runtime..."
    "${CROSS_COMPILE}strip" ./_install/bin/nvdla_runtime
else
    echo "Warning: nvdla_runtime not found at ../nvdla/sw/umd/out/apps/runtime/nvdla_runtime/nvdla_runtime"
fi

cp "/home/shc/temp/fast-math.nvdla" ./_install;
cp "/home/shc/temp/0_8.jpg" ./_install;
cp "./logo.txt" ./_install;

cd _install;
mkdir -p dev proc sys etc/init.d;
sudo rm -rf dev/console dev/null;
sudo mknod dev/console c 5 1;
sudo mknod dev/null c 1 3;
#sudo mknod dev/ttyS0 c 4 64;

echo '#!/bin/sh' > ./etc/init.d/rcS
echo 'mount -t devtmpfs devtmpfs /dev' >> ./etc/init.d/rcS
echo 'mount -t proc none /proc' >> ./etc/init.d/rcS
echo 'mount -t sysfs none /sys' >> ./etc/init.d/rcS

echo 'cat logo.txt' >> ./etc/init.d/rcS
if [ "$BENCH" = "1" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
#echo 'ls -al' >> ./etc/init.d/rcS
#echo 'chmod +x ./basicmath_small' >> ./etc/init.d/rcS
#echo 'chmod +x ./runme_small.sh' >> ./etc/init.d/rcS
#echo 'time ./runme_small.sh' >> ./etc/init.d/rcS

echo './basicmath_small > output_small1.txt' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "2" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './dijkstra_small input.dat > output_small2.dat' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "3" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './search_small > output_small3.txt' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "4" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './rijndael input_small.asc output_small.enc e 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321 && ./rijndael output_small.enc output_small.dec d 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "5" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './sha input_small.asc > output_small4.txt' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "6" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './fft 4 4096 > output_small.txt && ./fft 4 8192 -i > output_small.inv.txt' >> ./etc/init.d/rcS
fi

if [ "$BENCH" = "7" ]; then
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo './cjpeg -dct int -progressive -opt -outfile output_small_encode.jpeg input_small.ppm && ./djpeg -dct int -ppm -outfile output_small_decode.ppm input_small.jpg' >> ./etc/init.d/rcS

#echo 'tail -n 10 output_small.txt' >> ./etc/init.d/rcS
#echo 'cat output_small.txt' >> ./etc/init.d/rcS
fi

#echo 'ls -al' >> ./etc/init.d/rcS
#echo 'exec /bin/sh' >> ./etc/init.d/rcS
echo 'exec setsid cttyhack /bin/sh' >> ./etc/init.d/rcS

chmod +x ./etc/init.d/rcS;
ln -s ./etc/init.d/rcS ./init;
# find . | cpio -H newc -o --owner root:root | gzip > ../rootfs.cpio.gz;
find . | cpio -H newc -o --owner root:root > ../rootfs.cpio;
