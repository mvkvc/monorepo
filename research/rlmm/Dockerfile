ARG PLATFORM=CPU
ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=11.7.1

FROM ubuntu:$UBUNTU_VERSION as CPU

FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-runtime-ubuntu$UBUNTU_VERSION as GPU

FROM $PLATFORM as base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    apt-utils \
    software-properties-common \
    build-essential \
    wget \
    git

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    python3-distutils \
    python-is-python3
RUN python -V
RUN pip install --upgrade pip
RUN pip -V

FROM base as build

COPY . /app/

WORKDIR /app

RUN python -m pip install -r requirements_no_gpu.txt
# Install any gpu dependencies directly
RUN python -m pip install torch

# CMD ["jupyter", "lab", "--notebook-dir=./nbs", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
