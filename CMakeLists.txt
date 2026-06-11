cmake_minimum_required(VERSION 3.18)

project(cuda_hello_world LANGUAGES CXX CUDA)

if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    # Generate native machine code only. This avoids requiring the installed
    # NVIDIA driver to JIT-compile PTX produced by a newer CUDA toolkit.
    set(CMAKE_CUDA_ARCHITECTURES 89-real)
endif()

add_executable(cuda_hello_world
    src/main.cu
)

add_executable(cuda_device_info
    src/device_info.cu
)

set_target_properties(cuda_hello_world cuda_device_info PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CUDA_STANDARD 17
    CUDA_STANDARD_REQUIRED ON
)
