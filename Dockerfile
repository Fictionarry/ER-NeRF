ARG BASE_IMAGE=nvcr.io/nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
FROM $BASE_IMAGE

VOLUME [ "/ernerf" ]

RUN apt-get update -yq --fix-missing \
 && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    pkg-config \
    wget \
    cmake \
    curl \
    git \
    vim \
    portaudio19-dev \
    ffmpeg \
    libsm6 \
    libxext6

SHELL ["/bin/bash", "-i", "-c"] 

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN sh Miniconda3-latest-Linux-x86_64.sh -b -u -p ~/miniconda3
RUN ~/miniconda3/bin/conda init
RUN source ~/.bashrc
RUN rm Miniconda3-latest-Linux-x86_64.sh

RUN conda install nvidia/label/cuda-11.7.1::libcufft nvidia/label/cuda-11.7.1::libcublas nvidia/label/cuda-11.7.1::libnvjpeg nvidia/label/cuda-11.7.1::libcusparse nvidia/label/cuda-11.7.1::cuda-cudart conda-forge::libnvjitlink-dev nvidia/label/cuda-11.7.1::cuda-toolkit -y
RUN conda remove libnvjitlink-dev -y
RUN conda install python==3.10 pytorch==1.13.1 torchvision==0.14.1 cudatoolkit==11.7.1 -c pytorch -y
COPY requirements.txt ./
RUN pip install -r requirements.txt

RUN conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
RUN conda install -c bottler nvidiacub -y
# RUN pip install "git+https://github.com/facebookresearch/pytorch3d.git"
RUN pip install --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py310_cu117_pyt1131/download.html

RUN pip install tensorflow-gpu==2.8.0

RUN pip uninstall protobuf -y
RUN pip install protobuf==3.20.1

# RUN conda install ffmpeg -y

RUN echo 'export LD_LIBRARY_PATH="$CONDA_PREFIX/lib"' >> ~/.bashrc
RUN ln -s $CONDA_PREFIX/lib/libcudart.so /usr/lib/libcudart.so

COPY ./ /ernerf
WORKDIR /ernerf

CMD ["/bin/bash"]
