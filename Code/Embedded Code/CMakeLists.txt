cmake_minimum_required(VERSION 3.24)
project(Embedded_Code)

set(CMAKE_CXX_STANDARD 17)

add_executable(Embedded_Code main.cpp Sensors.h Wireless.h)

set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 28)
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)
set(CMAKE_ANDROID_NDK /path/to/android-ndk)
set(CMAKE_ANDROID_NDK_TOOLCHAIN_VERSION clang)
