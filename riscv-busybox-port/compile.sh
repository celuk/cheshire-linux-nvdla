#!/bin/bash

sudo rm -rf ./_install ./rootfs.cpio.gz;
make distclean;
make defconfig;
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config;
export CROSS_COMPILE=../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-;
make -j14;
make install;

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
echo 'echo "Loading OpenDLA kernel module..."' >> ./etc/init.d/rcS
echo 'insmod /opendla.ko' >> ./etc/init.d/rcS
echo 'cat logo.txt' >> ./etc/init.d/rcS
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
echo 'echo "rcS: alive" > /dev/ttyS0 2>/dev/null || true' >> ./etc/init.d/rcS
echo 'cat /proc/interrupts > /dev/kmsg 2>/dev/null || true' >> ./etc/init.d/rcS
#echo 'ls -al' >> ./etc/init.d/rcS
#echo 'exec /bin/sh' >> ./etc/init.d/rcS
echo 'exec /bin/sh </dev/ttyS0 >/dev/ttyS0 2>&1' >> ./etc/init.d/rcS

chmod +x ./etc/init.d/rcS;
ln -s ./etc/init.d/rcS ./init;
# find . | cpio -H newc -o --owner root:root | gzip > ../rootfs.cpio.gz;
find . | cpio -H newc -o --owner root:root > ../rootfs.cpio;
