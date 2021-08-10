
#include <vector> 
#include <pybind11/pybind11.h> 
#include <pybind11/stl.h> 
#include <pybind11/numpy.h> 
#include <chrono> 
#include <thread> 
#include <iostream> 
#include <fstream> 
#include <cstdlib> 
#include <string> 
#include <vector> 
#include <cmath> 
#include <ctime> 
#include <cuda_runtime.h> 

extern "C" void gpu_sobel(int *l_source_array, int *l_result_array,int src_rows, int src_column_size);

#ifndef LOAD_IMAGE_H 
#define LOAD_IMAGE_H 
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"



namespace py = pybind11;

py::array load_img(const char* path){

const char *path_to_input_image = path;
int width, height, channels;

stbi_uc* image = stbi_load(path_to_input_image, &width, &height, &channels, STBI_rgb_alpha);

auto out = std::vector<std::vector<std::vector<uint8_t>>>();
auto r_channel = std::vector<std::vector<uint8_t>>();
auto b_channel = std::vector<std::vector<uint8_t>>();
auto g_channel = std::vector<std::vector<uint8_t>>();

for (auto i = 0; i < height; i++) {
      r_channel.push_back(std::vector<uint8_t>(width));
      g_channel.push_back(std::vector<uint8_t>(width));
      b_channel.push_back(std::vector<uint8_t>(width));
for(auto j = 0;j< width;j++){
      stbi_uc* p = image + (STBI_rgb_alpha * (i * (width) + j));
      r_channel[i][j] = p[0];
      g_channel[i][j] = p[1];
      b_channel[i][j] = p[2];     
      }
    }

out.push_back(b_channel);
out.push_back(g_channel);
out.push_back(r_channel);

py::array ret_out = py::cast(out);

return ret_out;

}


py::array cuda_sobel(py::array_t<uint8_t> img){

int height = img.shape(1); 
int width = img.shape(2); 
int dest_size = (height)*(width); 

int *l_result_array = 0; 
l_result_array = new int[dest_size]; 

int src_height = height+2;
int src_width = width+2;
int src_size = src_height*src_width;

int* l_source_array = 0; 
l_source_array = new int[src_size];  

for (auto row = 0; row < src_height; row++) {    
    for (auto col = 0; col < src_width; col++) { 
      if (row == 0 || row == src_height-1 || col == 0 || col == src_width-1){
      l_source_array[row * src_width + col] = 0;}
      else{
      l_source_array[row * src_width + col] = img.at(0,row-1,col-1);}
    } 
} 

gpu_sobel(l_source_array, l_result_array, src_height, src_width); 

auto out = std::vector<std::vector<uint8_t>>();

for (auto row = 0; row < height; row++) {
    out.push_back(std::vector<uint8_t>(width));
    for (auto col = 0; col < width; col++) {
      out[row][col] = l_result_array[(row)*(width) + (col)];
    }
  }

py::array result = py::cast(out);
return result;

} 


PYBIND11_MODULE(gpucv, m) {
    m.doc() = "just a simple cv lib on cuda";
    m.def("readimg", &load_img);
    m.def("sobel",&cuda_sobel);
}

#endif
