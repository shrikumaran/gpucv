# gpucv

<!--[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/shrikumaran/gpucv/blob/main/gpucv.ipynb)-->

Have you used OpenCV on your CPU, and wanted to run it on GPU. Did you try installing OpenCV and get frustrated with its installation.
Fret not gpucv is here to save the day. 
Simple installation and runs as good as OpenCV on GPU.

You need to still install all the Nvidia drivers if you don't have them.

### Requirements 
- Python 3.7
- CUDA

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
sobel = gpucv.sobel(img)
```
Colab noteobook: https://colab.research.google.com/drive/1o0LD56Qo88lZZtfVqshZL-rvCZUJ19ex?usp=sharing

### TODO
- Basic IP stuff (grayscale,resize,threshold)
- Implement filters (mean,gaussian and sobel)
- Convolution kernels

