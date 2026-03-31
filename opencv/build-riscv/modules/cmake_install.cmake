# Install script for directory: /home/shc/projects/cheshire-linux-nvdla/opencv/modules

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/shc/projects/cheshire-linux-nvdla/opencv-riscv-install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/home/shc/projects/cheshire-linux-nvdla/riscv-toolchain-custom/_install/bin/riscv64-unknown-linux-gnu-objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xdevx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/opencv4/3rdparty" TYPE STATIC_LIBRARY FILES "/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/lib/libade.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xlicensesx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/licenses/opencv4" TYPE FILE RENAME "ade-LICENSE" FILES "/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/3rdparty/ade/ade-0.1.1f/LICENSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/calib3d/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/core/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/dnn/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/features2d/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/flann/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/gapi/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/highgui/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/imgcodecs/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/imgproc/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/java/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/js/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/ml/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/objdetect/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/photo/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/python/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/stitching/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/ts/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/video/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/videoio/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/.firstpass/world/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/core/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/imgproc/cmake_install.cmake")
  include("/home/shc/projects/cheshire-linux-nvdla/opencv/build-riscv/modules/imgcodecs/cmake_install.cmake")

endif()

