cmake_minimum_required(VERSION 3.4...3.18)
project(gpucv LANGUAGES CUDA CXX)
add_subdirectory(pybind11)
#add_library(sobel STATIC sobel.cu)


pybind11_add_module(gpucv gpucv/src/mod.cpp)

#add_library(cuda_gpu STATIC mod.cpp)

#add_library(gpu_lib SHARED mod.cpp sobel.cu)

#target_link_libraries(gpu_lib ${PYTHON_LIBRARIES} ${CUDA_LIBRARIES})


