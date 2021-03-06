#include "AudioFir.cuh"
#include "helper_cuda.h"
#include "stdio.h"

#define K 512
#define N 1024
__constant__ static float fir_coeff[N + 1];

__global__ static void audiofir_kernel(float* yout, float* yin, int n,
                                       int len) {
  int i = threadIdx.x + blockIdx.x * blockDim.x;

  int j;
  float y_out = 0;
  for (j = 0; j <= n; j++) {
    y_out += yin[i - j] * fir_coeff[j];
  }
  yout[i] = y_out;
}

void audiofir::audiofir(float* yout, float* yin, float* coeff, int n, int len,
                        ...) {
  checkCudaErrors(cudaSetDevice(0));
  float *filter, *y_in, *y_out;

  int L = ((len + K - 1) / K) * K;

  checkCudaErrors(cudaMalloc(&filter, (n + 1) * sizeof(float)));
  checkCudaErrors(cudaMalloc(&y_in, (2 * (L + n)) * sizeof(float)));
  checkCudaErrors(cudaMalloc(&y_out, (2 * (L)) * sizeof(float)));
  checkCudaErrors(cudaMemset((void*)y_in, 0, (2 * (L + n)) * sizeof(float)));
  checkCudaErrors(cudaMemcpyToSymbol(fir_coeff, coeff, (N + 1) * sizeof(float),
                                     0, cudaMemcpyHostToDevice));

  checkCudaErrors(cudaMemcpy(filter, coeff, (n + 1) * sizeof(float),
                             cudaMemcpyHostToDevice));
  checkCudaErrors(
      cudaMemcpy(y_in + n, yin, (len) * sizeof(float), cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy((y_in + L + 2 * n), yin + len,
                             (len) * sizeof(float), cudaMemcpyHostToDevice));
  cudaEvent_t start, stop;  // pomiar czasu wykonania jadra
  checkCudaErrors(cudaEventCreate(&start));
  checkCudaErrors(cudaEventCreate(&stop));
  checkCudaErrors(cudaEventRecord(start, 0));
  audiofir_kernel<<<(len + K - 1) / K, K>>>(y_out, y_in + n, n, len);
  checkCudaErrors(cudaGetLastError());

  checkCudaErrors(cudaEventRecord(stop, 0));
  checkCudaErrors(cudaEventSynchronize(stop));
  float elapsedTime;
  checkCudaErrors(cudaEventElapsedTime(&elapsedTime, start, stop));
  checkCudaErrors(cudaEventDestroy(start));
  checkCudaErrors(cudaEventDestroy(stop));

  checkCudaErrors(cudaDeviceSynchronize());
  audiofir_kernel<<<(len + K - 1) / K, K>>>(y_out + len, (y_in + L + 2 * n), n,
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
