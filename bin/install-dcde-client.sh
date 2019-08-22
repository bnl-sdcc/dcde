#!/bin/bash -e
# 
# Script to install and maintain parsl for all users on system. 
#
#  python 3.6
#  parsl
#  oauth-ssh
#  urllib3
#  chardet
#  
#   conda create -n dcde python=3.6
#   conda activate dcde
#   pip install parsl 
#   oauth-ssh==0.9
#   pip install paramiko==2.4.2
#   pip install cryptography==2.4.2 

wget https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
bash Anaconda3-5.3.1-Linux-x86_64.sh -u -f -b -p ~/
export PATH=~/bin:$PATH
conda update -n base -c defaults conda
conda create -n dcde python=3.6
conda init bash
source activate dcde
pip install parsl

