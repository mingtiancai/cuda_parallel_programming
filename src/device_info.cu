#include <cuda_runtime.h>

#include <cstdio>
#include <cstdlib>

void check_cuda(cudaError_t result, const char* operation)
{
    if (result != cudaSuccess) {
        std::fprintf(
            stderr,
            "CUDA error during %s: %s\n",
            operation,
            cudaGetErrorString(result)
        );
        std::exit(EXIT_FAILURE);
    }
}

int main()
{
    int driver_version = 0;
    int runtime_version = 0;
    int device_count = 0;

    check_cuda(cudaDriverGetVersion(&driver_version), "driver version query");
    check_cuda(cudaRuntimeGetVersion(&runtime_version), "runtime version query");
    check_cuda(cudaGetDeviceCount(&device_count), "device count query");

    std::printf(
        "CUDA driver API version: %d.%d\n",
        driver_version / 1000,
        (driver_version % 1000) / 10
    );
    std::printf(
        "CUDA runtime version:    %d.%d\n",
        runtime_version / 1000,
        (runtime_version % 1000) / 10
    );
    std::printf("CUDA device count:       %d\n", device_count);

    for (int device = 0; device < device_count; ++device) {
        cudaDeviceProp properties{};
        check_cuda(
            cudaGetDeviceProperties(&properties, device),
            "device properties query"
        );

        std::printf("\nDevice %d: %s\n", device, properties.name);
        std::printf(
            "  Compute Capability: %d.%d (CMake architecture: %d%d-real)\n",
            properties.major,
            properties.minor,
            properties.major,
            properties.minor
        );
        std::printf(
            "  Global memory:      %.2f GiB\n",
            static_cast<double>(properties.totalGlobalMem) /
                (1024.0 * 1024.0 * 1024.0)
        );
        std::printf("  Multiprocessors:     %d\n", properties.multiProcessorCount);
        std::printf("  Max threads/block:   %d\n", properties.maxThreadsPerBlock);
    }

    return EXIT_SUCCESS;
}
