# config include file for fletcher
# common for all backends

# Compilers
GCC=gcc
NVCC=nvcc
ICC=icc
PGCC=pgcc
CLANG=clang

# Library paths
GCC_LIBS=-lm
NVCC_LIBS=-lcudart -lstdc++    # it may include CUDA lib64 path...
ICC_LIBS=-lm -xHost -Wall -Wextra 
PGCC_LIBS=-lm
CLANG_LIBS=-lm

# PAPI flags
PAPI_LIBS=-lpapi
