#include <cuda_runtime.h>

#include <cstdio>
#include <cstdlib>

__global__ void hello_from_gpu()
{
    printf("Hello World from GPU!\n");
}

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
    std::printf("Hello World from CPU!\n");

    hello_from_gpu<<<1, 1>>>();
    check_cuda(cudaGetLastError(), "kernel launch");
    check_cuda(cudaDeviceSynchronize(), "device synchronization");

    return EXIT_SUCCESS;
}

