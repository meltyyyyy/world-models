FROM nvidia/cuda:11.3.0-cudnn8-runtime-ubuntu18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    wget \
    vim \
    git \
    build-essential \
    python-opengl

WORKDIR /opt

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY environment.yml .

RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    conda env create -n mwm -f environment.yml && \
    conda init && \
    echo "conda activate mwm" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV mwm && \
   PATH /opt/conda/envs/mwm/bin:$PATH

RUN mkdir -p /root/world-models
COPY ./ /root/world-models
WORKDIR /root/world-models
ENV HOME /root

CMD ["/bin/bash"]
