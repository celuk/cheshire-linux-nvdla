set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLCHAIN_PREFIX="${ROOT_DIR}/../riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-"
BUILD_DIR="${ROOT_DIR}/build-riscv"
NVDLA_SW_DIR="${ROOT_DIR}/../nvdla/sw"
NVDLA_RUNTIME_LIB="${NVDLA_SW_DIR}/umd/out/core/src/runtime/libnvdla_runtime/libnvdla_runtime.a"
NVDLA_COMPILER_LIB="${NVDLA_SW_DIR}/umd/out/core/src/compiler/libnvdla_compiler/libnvdla_compiler.a"

if [ ! -f "${NVDLA_RUNTIME_LIB}" ] || [ ! -f "${NVDLA_COMPILER_LIB}" ]; then
  echo "NVDLA runtime/compiler libraries not found, building nvdla/sw first..."
  "${NVDLA_SW_DIR}/compile.sh"
fi

SYSROOT="$(${TOOLCHAIN_PREFIX}gcc --print-sysroot)"

cmake -S "${ROOT_DIR}" -B "${BUILD_DIR}" \
  -DTENGINE_ENABLE_OPENDLA=ON \
  -DTENGINE_ENABLE_RISCV_LP64DV_OPT=OFF \
  -DTENGINE_BUILD_SHARED=OFF \
  -DNVDLA_SW_ROOT="${NVDLA_SW_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=riscv64 \
  -DCMAKE_C_COMPILER="${TOOLCHAIN_PREFIX}gcc" \
  -DCMAKE_CXX_COMPILER="${TOOLCHAIN_PREFIX}g++" \
  -DCMAKE_ASM_COMPILER="${TOOLCHAIN_PREFIX}gcc" \
  -DCMAKE_AR="${TOOLCHAIN_PREFIX}ar" \
  -DCMAKE_RANLIB="${TOOLCHAIN_PREFIX}ranlib" \
  -DCMAKE_STRIP="${TOOLCHAIN_PREFIX}strip" \
  -DCMAKE_SYSROOT="${SYSROOT}" \
  -DCMAKE_FIND_ROOT_PATH="${SYSROOT}" \
  -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY

cmake --build "${BUILD_DIR}" --target tm_classification_opendla -j"$(nproc)"

if cmake --build "${BUILD_DIR}" --target help | grep -q "tm_yolox_opendla"; then
  cmake --build "${BUILD_DIR}" --target tm_yolox_opendla -j"$(nproc)"
else
  echo "Skipping tm_yolox_opendla: target is not generated (OpenCV not found for cross-compile)."
fi
