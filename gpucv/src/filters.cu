#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void cu_sobel(int *orig, int *cpu, int height,int width){

    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;

    float dx, dy;
    if( x > 0 && y > 0 && x < width-1 && y < height-1) {
        dx = (-1* orig[(y-1)*width + (x-1)]) + (-2*orig[y*width+(x-1)]) + (-1*orig[(y+1)*width+(x-1)]) +
             (    orig[(y-1)*width + (x+1)]) + ( 2*orig[y*width+(x+1)]) + (   orig[(y+1)*width+(x+1)]);
        dy = (    orig[(y-1)*width + (x-1)]) + ( 2*orig[(y-1)*width+x]) + (   orig[(y-1)*width+(x+1)]) +
             (-1* orig[(y+1)*width + (x-1)]) + (-2*orig[(y+1)*width+x]) + (-1*orig[(y+1)*width+(x+1)]);
        cpu[(y)*(width) + (x)] = sqrt( (dx*dx) + (dy*dy) );
    }
}

// Called from driver program.  Handles running GPU calculation
extern "C" void gpu_sobel(int *l_source_array, int *l_result_array,int src_rows, int src_column_size) {
  int num_bytes_source = src_column_size * src_rows * sizeof(int);
  int *l_source_array_d;
  int *l_result_array_d;

  cudaMalloc((void **)&l_source_array_d, num_bytes_source);
  cudaMemcpy(l_source_array_d, l_source_array, num_bytes_source,cudaMemcpyHostToDevice);

  int result_column_size = src_column_size; 
  int result_row_size = src_rows;
  int num_bytes_result = result_column_size * result_row_size * sizeof(int);
  cudaMalloc((void **)&l_result_array_d, num_bytes_result);



  dim3 threadsPerBlock(32, 32);

  dim3 numBlocks(ceil(src_column_size/32), ceil(src_rows/32), 1);

  cu_sobel<<<numBlocks, threadsPerBlock>>>(l_source_array_d, l_result_array_d,
                                      src_rows, src_column_size);

  cudaMemcpy(l_result_array, l_result_array_d, num_bytes_result,
             cudaMemcpyDeviceToHost);


  cudaFree(l_source_array_d);
  cudaFree(l_result_array_d);
}
