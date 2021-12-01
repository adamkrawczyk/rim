#ifndef AUDIO_FIR_HPP
#define AUDIO_FIR_HPP

// CUDA runtime
#include </usr/include/cuda_runtime.h>

// helper functions and utilities to work with CUDA
#include <helper_cuda.h>
#include <helper_functions.h>

#include "/usr/include/device_launch_parameters.h"

namespace audiofir {

void audiofir(float* yout, float* yin, float* coeff, int n, int len, ...);

}  // namespace audiofir

#endif  // AUDIO_FIR_HPP
