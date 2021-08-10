cmake_minimum_required(VERSION 3.4...3.18)
project(gpucv LANGUAGES CUDA CXX)
add_subdirectory(pybind11)
find_package(pybind11 REQUIRED)

#add_subdirectory(pybind11/include/pybind11)

#add_library(sobel STATIC sobel.cu)

pybind11_add_module(gpucv gpucv/src/mod.cpp gpucv/src/filters.cu)

#add_library(cuda_gpu STATIC mod.cpp)

#add_library(gpucv SHARED gpucv/src/mod.cpp gpucv/src/filters.cu)
#target_link_libraries(gpucv ${PYTHON_LIBRARIES} ${CUDA_LIBRARIES})
#set_target_properties(gpucv PROPERTIES PREFIX "")
#target_link_libraries(gpu_lib ${PYTHON_LIBRARIES} ${CUDA_LIBRARIES})


