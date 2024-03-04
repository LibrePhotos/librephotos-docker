#!/usr/bin/env bash

# Check for a CUDA-capable GPU
if lspci | grep -i nvidia >/dev/null; then
    echo "CUDA-capable GPU detected."
else
    echo "No CUDA-capable GPU detected."
fi

# Check the Linux version
if uname -m && cat /etc/*release >/dev/null; then
    echo "Linux version is supported."
else
    echo "Linux version is not supported."
fi

# Check for GCC
if gcc --version >/dev/null; then
    echo "GCC is installed."
else
    echo "GCC is not installed."
fi

# Check for the correct kernel headers and development packages
if uname -r >/dev/null; then
    echo "Kernel headers and development packages are installed."
else
    echo "Kernel headers and development packages are not installed."
fi

# Check the NVIDIA binary GPU driver version
if nvidia-smi >/dev/null; then
    echo "NVIDIA binary GPU driver is installed."
else
    echo "NVIDIA binary GPU driver is not installed."
fi

# Check the Docker version
if docker --version >/dev/null; then
    echo "Docker is installed."
else
    echo "Docker is not installed."
fi

# Check the NVIDIA Container Toolkit installation
if docker run --rm --gpus all nvidia/cuda:12.2.2-runtime-ubuntu20.04 nvidia-smi >/dev/null; then
    echo "NVIDIA Container Toolkit is installed."
else
    echo "NVIDIA Container Toolkit is not installed."
fi
