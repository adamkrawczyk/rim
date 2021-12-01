#include "AudioFir.cuh"
#include "helper_cuda.h"
#include "stdio.h"

#define K 512

__global__ static void audiofir_kernel(float* yout, float* yin, float* coeff,
                                       int n, int len) {
  int i = threadIdx.x + blockIdx.x * blockDim.x;
  if (i < len) {
    int j;
    float y_out = 0;
    for (j = 0; j <= n; j++) {
      if (i >= j) {
        y_out += yin[i - j] * coeff[j];
      }
    }
    yout[i] = y_out;
  }
}

void audiofir::audiofir(float* yout, float* yin, float* coeff, int n, int len,
                        ...) {
  checkCudaErrors(cudaSetDevice(0));
  float *filter, *y_in, *y_out;
  checkCudaErrors(cudaMalloc(&filter, (n + 1) * sizeof(float)));
  checkCudaErrors(cudaMalloc(&y_in, (2 * len) * sizeof(float)));
  checkCudaErrors(cudaMalloc(&y_out, (2 * len) * sizeof(float)));
  checkCudaErrors(cudaMemcpy(filter, coeff, (n + 1) * sizeof(float),
                             cudaMemcpyHostToDevice));
  checkCudaErrors(
      cudaMemcpy(y_in, yin, (2 * len) * sizeof(float), cudaMemcpyHostToDevice));

  cudaEvent_t start, stop;  // pomiar czasu wykonania j?dra
  checkCudaErrors(cudaEventCreate(&start));
  checkCudaErrors(cudaEventCreate(&stop));
  checkCudaErrors(cudaEventRecord(start, 0));
  audiofir_kernel<<<(len + K - 1) / K, K>>>(y_out, y_in, filter, n, len);
  checkCudaErrors(cudaGetLastError());

  checkCudaErrors(cudaEventRecord(stop, 0));
  checkCudaErrors(cudaEventSynchronize(stop));
  float elapsedTime;
  checkCudaErrors(cudaEventElapsedTime(&elapsedTime, start, stop));
  checkCudaErrors(cudaEventDestroy(start));
  checkCudaErrors(cudaEventDestroy(stop));

  checkCudaErrors(cudaDeviceSynchronize());
  audiofir_kernel<<<(len + K - 1) / K, K>>>(y_out + len, y_in + len, filter, n,
                                            len);
  checkCudaErrors(cudaGetLastError());
  checkCudaErrors(cudaDeviceSynchronize());

  checkCudaErrors(cudaMemcpy(yout, y_out, (2 * len) * sizeof(float),
                             cudaMemcpyDeviceToHost));
  checkCudaErrors(cudaFree(filter));
  checkCudaErrors(cudaFree(y_in));
  checkCudaErrors(cudaFree(y_out));

  checkCudaErrors(cudaDeviceReset());
  printf("GPU (kernel) time = %.3f ms (%6.3f GFLOP/s)\n", elapsedTime,
         1e-6 * 2 * ((double)n + 1) * 2 * ((double)len) / elapsedTime);
}
