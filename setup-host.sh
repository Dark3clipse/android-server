#!/bin/bash
sudo apt-get update -qqy
sudo apt-get install v4l2loopback-dkms python python-pip imagemagick -y
sudo modprobe v4l2loopback
pip install scipy pillow v4l2 numpy