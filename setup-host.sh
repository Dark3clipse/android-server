#!/bin/bash

# update apt
sudo apt-get update -qqy

# install magick
sudo apt-get install build-essential checkinstall && sudo apt-get build-dep imagemagick -y
sudo wget http://www.imagemagick.org/download/ImageMagick.tar.gz
sudo tar xzvf ImageMagick.tar.gz
cd ImageMagick-7.0.10-60/
sudo ./configure --enable-shared --with-png=yes
sudo make clean
sudo make
sudo checkinstall
sudo ldconfig /usr/local/lib

# install other dependencies
sudo apt-get install v4l2loopback-dkms python python-pip ffmpeg -y

sudo modprobe v4l2loopback
pip install scipy pillow v4l2 numpy