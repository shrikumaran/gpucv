# gpucv


An easy to use Pythonic image processing library accelerated with CUDA.

### Requirements 
Python 3.7

### Installation

1. Using pip
```
pip3 install gpucv
```

2. Building the project
Clone the project to your local repo and run setup.py.
```
git clone git@github.com:shrikumaran/gpucv.git
python3 setup.py bdist_wheel
```

### Example
```python
import gpucv
img = gpucv.readimg('index.jpeg')
```
Colab noteobook: https://colab.research.google.com/drive/1o0LD56Qo88lZZtfVqshZL-rvCZUJ19ex?usp=sharing

### TODO
- Basic IP stuff (grayscale,resize,threshold)
- Implement filters (mean,gaussian and sobel)
- Convolution kernels

