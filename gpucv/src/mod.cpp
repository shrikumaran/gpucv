#ifndef LOAD_IMAGE_H
#define LOAD_IMAGE_H

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
    }

for (auto i = 0; i < height; i++) {
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


PYBIND11_MODULE(gpucv, m) {
    m.doc() = "just a simple cv lib on cuda";
    m.def("readimg", &load_img);
}

#endif
