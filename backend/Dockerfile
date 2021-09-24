FROM ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
        build-essential \
        ca-certificates \
        curl \
        git \
        libpq-dev \
        libtinfo5 \
        python-is-python3 \
        python3-dev \
        python3-pip \
        imagemagick \
        libimage-exiftool-perl \
        libmagic1 \
        libraw-bin \
        libvips \
        rustc

FROM base AS data_models

# Pre trained models
WORKDIR /data_models

RUN mkdir -p /root/.cache/torch/hub/checkpoints/ && \
	curl -SL https://github.com/LibrePhotos/librephotos-docker/releases/download/0.1/places365.tar.gz | tar -zxC /data_models/ && \
	curl -SL https://github.com/LibrePhotos/librephotos-docker/releases/download/0.1/im2txt.tar.gz | tar -zxC /data_models/ && \
	curl -SL https://github.com/LibrePhotos/librephotos-docker/releases/download/0.1/clip-embeddings.tar.gz | tar -zxC /data_models/ && \
	curl -SL https://download.pytorch.org/models/resnet152-b121ed2d.pth -o /root/.cache/torch/hub/checkpoints/resnet152-b121ed2d.pth

# Project Python requirements
FROM data_models AS python_requirements

RUN pip3 install --no-cache --upgrade pip && \
    pip3 install --no-cache --upgrade cmake==3.21.2 pyvips==2.1.15

ARG DEBUG
WORKDIR /code

RUN git clone https://github.com/LibrePhotos/librephotos . && \
    pip3 install --no-cache -r requirements.txt

RUN if [ "$DEBUG" = 1 ] ; then \
        pip3 install --no-cache -r requirements.dev.txt ;  \
    fi
FROM python_requirements AS faiss

# Dependencies to build faiss
RUN apt-get update && apt-get install -y --no-install-recommends \
        libopenblas-dev \
        swig

WORKDIR /tmp/builds
RUN git clone --depth 1 --branch 'v1.7.1' https://github.com/facebookresearch/faiss.git && \
	cd faiss  && \
	cmake -B build . -DCMAKE_BUILD_TYPE=Release -DFAISS_ENABLE_GPU=OFF -DFAISS_ENABLE_PYTHON=ON -DFAISS_OPT_LEVEL=generic  && \
	make -C build -j4 faiss && \
	make -C build -j4 swigfaiss && \
	cd build/faiss/python && \
	python3 setup.py install

# Finally, clean up and set the entry point
FROM faiss AS project

EXPOSE 8001

# Clean up the image
RUN apt-get remove --purge --yes build-essential \
        build-essential \
        ca-certificates \
        curl \
        git \
        python3-dev && \
    pip3 uninstall --yes cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -fr /tmp

COPY entrypoint.sh /entrypoint.sh

WORKDIR /code
CMD ["/entrypoint.sh"]
