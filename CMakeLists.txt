cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(cmake_and_cuda LANGUAGES CXX CUDA)

set(BUILD_TYPE Release)
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11" )

include_directories("${PROJECT_SOURCE_DIR}/include/")
include_directories("/home/adam/Downloads/cuda-samples/Common/")
include_directories("/home/adam/Downloads/cuda-samples/Samples/")

add_executable(main src/main.cu src/AudioFir.cu)

set_property(TARGET main 
             PROPERTY CUDA_SEPARABLE_COMPILATION ON)