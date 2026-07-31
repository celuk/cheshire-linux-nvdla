#!/bin/bash

rm -rf ./_install ./rootfs.cpio ./rootfs.cpio.gz;
make distclean;
make defconfig;
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config;
export CROSS_COMPILE=../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-;
make -j$(nproc);
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

# Copy misalign64
if [ -f "../misalign64/misalign64" ]; then
    echo "Copying misalign64..."
    cp "../misalign64/misalign64" ./_install/bin/misalign64
    chmod +x ./_install/bin/misalign64
else
    echo "Warning: misalign64 not found at ../misalign64/ (run: make misalign64)"
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

## Copy Tengine OpenDLA example binaries
#if [ -f "../tengine/build-riscv/examples/tm_classification_opendla" ]; then
#    echo "Copying tm_classification_opendla..."
#    cp "../tengine/build-riscv/examples/tm_classification_opendla" ./_install/bin/tm_classification_opendla
#    chmod +x ./_install/bin/tm_classification_opendla
#    echo "Stripping tm_classification_opendla..."
#    "${CROSS_COMPILE}strip" ./_install/bin/tm_classification_opendla
#else
#    echo "Warning: tm_classification_opendla not found at ../tengine/build-riscv/examples/"
#fi
##
#if [ -f "../tengine/build-riscv/examples/tm_yolox_opendla" ]; then
#    echo "Copying tm_yolox_opendla..."
#    cp "../tengine/build-riscv/examples/tm_yolox_opendla" ./_install/bin/tm_yolox_opendla
#    chmod +x ./_install/bin/tm_yolox_opendla
#    echo "Stripping tm_yolox_opendla..."
#    "${CROSS_COMPILE}strip" ./_install/bin/tm_yolox_opendla
#else
#    echo "Warning: tm_yolox_opendla not found at ../tengine/build-riscv/examples/"
#fi
#
#if [ -f "../tengine/build-riscv/examples/tm_yolov3_tiny_opendla" ]; then
#    echo "Copying tm_yolov3_tiny_opendla..."
#    cp "../tengine/build-riscv/examples/tm_yolov3_tiny_opendla" ./_install/bin/tm_yolov3_tiny_opendla
#    chmod +x ./_install/bin/tm_yolov3_tiny_opendla
#    echo "Stripping tm_yolov3_tiny_opendla..."
#    "${CROSS_COMPILE}strip" ./_install/bin/tm_yolov3_tiny_opendla
#else
#    echo "Warning: tm_yolov3_tiny_opendla not found at ../tengine/build-riscv/examples/"
#fi

#cp "../tengine/models/resnet18-cifar10-nosoftmax-relu_int8.tmfile" ./_install/;
cp "../tengine/models/yolox_nano_relu_int8.tmfile" ./_install/;
cp "../tengine/images/person.jpg" ./_install/;
cp "../tengine/images/cat.jpg" ./_install/;
cp "../tengine/images/dog.jpg" ./_install/;

cp "../nvdla/loadables/lenet/lenet-fast-math.nvdla" ./_install;
cp "../nvdla/loadables/resnet18-cifar10/cifar-default.nvdla" ./_install;
cp "../nvdla/loadables/resnet18-imagenet2012/imagenet-default.nvdla" ./_install;

cp "../nvdla/loadables/lenet/images/0_8.jpg" ./_install;
cp "../nvdla/loadables/resnet18-cifar10/images/cat_32.jpg" ./_install;
cp "../nvdla/loadables/resnet18-imagenet2012/images/331_hare.jpg" ./_install;
#cp "../nvdla/loadables/resnet18-imagenet2012/images/742_printer.jpg" ./_install;

##cp "../mibench/automotive/basicmath/basicmath_small" ./_install;
##"${CROSS_COMPILE}strip" ./_install/basicmath_small;
##cp "../mibench/automotive/basicmath/runme_small.sh" ./_install;
##
##cp "../mibench/network/dijkstra/dijkstra_small" ./_install;
##"${CROSS_COMPILE}strip" ./_install/dijkstra_small;
##cp "../mibench/network/dijkstra/input.dat" ./_install;
##
##cp "../mibench/office/stringsearch/search_small" ./_install;
##"${CROSS_COMPILE}strip" ./_install/search_small;
##
##cp "../mibench/security/rijndael/rijndael" ./_install;
##"${CROSS_COMPILE}strip" ./_install/rijndael;
###cp "../mibench/security/rijndael/input_small.asc" ./_install;
##
##cp "../mibench/security/sha/sha" ./_install;
##"${CROSS_COMPILE}strip" ./_install/sha;
##cp "../mibench/security/sha/input_small.asc" ./_install;
##
##cp "../lms/demo_st" ./_install;
##"${CROSS_COMPILE}strip" ./_install/demo_st;
##cp "../lms/lipsum" ./_install;

cp "./logo.txt" ./_install;

cd _install;
mkdir -p dev proc sys etc/init.d;
# /dev/console and /dev/null are added at cpio-pack time without root (see below).

echo '#!/bin/sh' > ./etc/init.d/rcS
echo 'mount -t devtmpfs devtmpfs /dev' >> ./etc/init.d/rcS
echo 'mount -t proc none /proc' >> ./etc/init.d/rcS
echo 'mount -t sysfs none /sys' >> ./etc/init.d/rcS
echo 'echo "Loading OpenDLA kernel module..."' >> ./etc/init.d/rcS
echo 'insmod ./opendla.ko' >> ./etc/init.d/rcS
echo 'cat logo.txt' >> ./etc/init.d/rcS
echo 'echo "Starting shell..."' >> ./etc/init.d/rcS
#echo 'ls -al' >> ./etc/init.d/rcS
#echo 'exec /bin/sh' >> ./etc/init.d/rcS

#echo 'nvdla_runtime --image 0_8.jpg --loadable lenet-fast-math.nvdla --rawdump' >> ./etc/init.d/rcS
#echo 'nvdla_runtime --image cat_32.jpg --loadable cifar-default.nvdla --rawdump' >> ./etc/init.d/rcS
#echo 'nvdla_runtime --image 331_hare.jpg --loadable imagenet-default.nvdla --rawdump' >> ./etc/init.d/rcS

#echo 'nvdla_runtime --image 742_printer.jpg --loadable imagenet-default.nvdla --rawdump' >> ./etc/init.d/rcS

##echo 'time ./basicmath_small > output_small1.txt' >> ./etc/init.d/rcS
##echo 'time ./dijkstra_small input.dat > output_small2.dat' >> ./etc/init.d/rcS
##echo 'time ./search_small > output_small3.txt' >> ./etc/init.d/rcS
##echo 'time ./rijndael input_small.asc output_small.enc e 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321 && time ./rijndael output_small.enc output_small.dec d 1234567890abcdeffedcba09876543211234567890abcdeffedcba0987654321' >> ./etc/init.d/rcS
##echo 'time ./sha input_small.asc > output_small5.txt' >> ./etc/init.d/rcS
##
##echo 'time ./demo_st genkey mykey sha2/5/1' >> ./etc/init.d/rcS
##echo 'time ./demo_st sign mykey lipsum' >> ./etc/init.d/rcS
##echo 'time ./demo_st verify mykey lipsum' >> ./etc/init.d/rcS
###echo 'time ./demo_st genkey mykey3 sha3/5/1' >> ./etc/init.d/rcS
###echo 'time ./demo_st sign mykey3 lipsum' >> ./etc/init.d/rcS
###echo 'time ./demo_st verify mykey3 lipsum' >> ./etc/init.d/rcS

echo 'exec setsid cttyhack /bin/sh' >> ./etc/init.d/rcS

chmod +x ./etc/init.d/rcS;
ln -sf ./etc/init.d/rcS ./init;
cd ..;

# Pack rootfs.cpio without root: the kernel's gen_init_cpio fabricates the
# device nodes from a text spec, so no sudo/mknod is needed.
BB="$(pwd)";
LINUX="$BB/../riscv-linux-port";
[ -x "$LINUX/usr/gen_init_cpio" ] || cc -O2 -o "$LINUX/usr/gen_init_cpio" "$LINUX/usr/gen_init_cpio.c";
printf 'nod /dev/console 0600 0 0 c 5 1\nnod /dev/null 0666 0 0 c 1 3\n' > "$BB/devnodes.list";
( cd "$LINUX" && sh usr/gen_initramfs.sh -u 0 -g 0 -o "$BB/rootfs.cpio" "$BB/_install" "$BB/devnodes.list" );
