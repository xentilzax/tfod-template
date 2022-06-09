FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

ARG TF_VERSION="2.5.0"
#solve trouble with tzdata
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#FIX GPG NVIDIA key error 
RUN rm -rf /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update

RUN apt-get install -y git python3-pip

RUN pip install --upgrade pip
RUN pip install tensorflow==${TF_VERSION}

RUN apt-get install -y protobuf-compiler python-pil python-lxml

RUN pip install jupyter
RUN pip install matplotlib

RUN mkdir -p /tensorflow/models && \
    git clone https://github.com/tensorflow/models.git /tensorflow/models

RUN cd /tensorflow/models/research && protoc object_detection/protos/*.proto --python_out=.

RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

RUN jupyter notebook --generate-config --allow-root
#RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py

WORKDIR /workspace

EXPOSE 8888

CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/workspace", "--ip=0.0.0.0", "--port=8888", "--no-browser"]

