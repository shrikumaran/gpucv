#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void cu_sobel(int *l_source_array_d, int *l_result_array_d, int rows,
                         int column_size) {
  int x_0, x_1, x_2, x_3, x_5, x_6, x_7, x_8, sum_0, sum_1, sum;
  int pos = blockIdx.x * column_size + threadIdx.x;
  int row = pos / column_size;
  int col = pos % column_size;

  bool top = (row == 0); 
  bool bottom = (row == (rows - 1)); 
  bool left_edge = (col == 0); 
  bool right_edge = (col == (column_size - 1)); 
  if (top == false && bottom == false && left_edge == false &&
      right_edge == false) {
    x_0 = l_source_array_d[(row - 1) * column_size + (col - 1)]; 
    x_1 = l_source_array_d[(row - 1) * column_size + (col)]; 
    x_2 = l_source_array_d[(row - 1) * column_size + (col + 1)]; 
    x_3 = l_source_array_d[(row)*column_size + (col - 1)];
    x_5 = l_source_array_d[(row)*column_size + (col + 1)];
    x_6 = l_source_array_d[(row + 1) * column_size + (col - 1)];
    x_7 = l_source_array_d[(row + 1) * column_size + (col)];
    x_8 = l_source_array_d[(row + 1) * column_size + (col + 1)];
    sum_0 = (x_0 + (2 * x_1) + x_2) - (x_6 + (2 * x_7) + x_8);
    sum_1 = (x_2 + (2 * x_5) + x_8) - (x_0 + (2 * x_3) + x_6);
    sum = sum_0 + sum_1;
    if (sum > 20) {
      sum = 255;
    } else {
      sum = 0;
    }
    l_result_array_d[((row - 1) * (column_size - 2)) + (col - 1)] = sum;
  }
}

// Called from driver program.  Handles running GPU calculation
extern "C" void gpu_sobel(int *l_source_array, int *l_result_array,
                          int src_rows, int src_column_size) {
  int num_bytes_source = src_column_size * src_rows * sizeof(int);
  int *l_source_array_d;
  int *l_result_array_d;

  cudaMalloc((void **)&l_source_array_d, num_bytes_source);
  cudaMemcpy(l_source_array_d, l_source_array, num_bytes_source,
             cudaMemcpyHostToDevice);

  int result_column_size = src_column_size - 2;
  int result_row_size = src_rows - 2;
  int num_bytes_result = result_column_size * result_row_size * sizeof(int);
  cudaMalloc((void **)&l_result_array_d, num_bytes_result);

  // block size should be adjusted to the problem size for performance
  dim3 block_size(src_column_size);
  // grid size should limit the amount of work to be completed
  dim3 grid_size(src_rows);

  cu_sobel<<<grid_size, block_size>>>(l_source_array_d, l_result_array_d,
                                      src_rows, src_column_size);

  // transfer results back to host
  cudaMemcpy(l_result_array, l_result_array_d, num_bytes_result,
             cudaMemcpyDeviceToHost);

  // release the memory on the GPU
  cudaFree(l_source_array_d);
  cudaFree(l_result_array_d);
}
