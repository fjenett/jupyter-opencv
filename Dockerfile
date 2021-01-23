FROM ubuntu:20.10
MAINTAINER Michele Dallachiesa <michele.dallachiesa@gmail.com>
# Container providing Jupyter notebook server with Python3 bindings for OpenCV 3.4.0
# Based on https://www.pyimagesearch.com/2016/10/24/ubuntu-16-04-how-to-install-opencv/
# Not compiling/installing templates, added gtk support

USER root

# Update package list, upgrade system and set default locale
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install apt-utils
RUN apt-get -y install locales
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure --frontend=noninteractive locales
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Install python3, and activate python3.9 as default python interpreter
RUN apt-get -y install python3-dev python3 python3-pip python3-venv
RUN pip3 install --upgrade pip
# RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

# Install OpenCV latest
RUN apt install -y libopencv-dev python3-opencv

# Install git
RUN apt-get -y install git

# Install wget and curl
RUN apt-get -y install wget curl

# Install python packages for data science
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Install additional system packages
RUN apt-get -y install x11-apps

# Create/populate /playground directory and define entrypoint
RUN mkdir /playground
COPY datasets /playground/datasets
COPY lab /playground/lab
COPY notebooks /playground/notebooks
RUN echo >/playground/WARNING:\ Any\ modification\ might\ be\ lost\ at\ container\ termination\!

ENV PYTHONPATH /playground
WORKDIR /playground
CMD ["jupyter", "lab", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.token=", "/playground"]

EXPOSE 8888/tcp

