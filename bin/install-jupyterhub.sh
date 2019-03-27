#!/bin/bash
# 
# Script to install and maintain a comanage-enabled Jupyterhub service.   
#
SETUP="Anaconda3-5.3.1-Linux-x86_64.sh"
PREFIX="/home/anaconda3"

if [ `whoami` != 'root' ] ; then
    echo "You must be root to do this."
    exit
fi
# Set up anaconda
echo "mkdir -p $PREFIX ~/tmp/"
mkdir -p $PREFIX ~/tmp/
echo "cd ~/tmp/"
cd ~/tmp/
echo "wget https://repo.anaconda.com/archive/$SETUP"
wget https://repo.anaconda.com/archive/$SETUP
echo "bash $SETUP -u -f -b -p $PREFIX"
bash $SETUP -u -f -b -p $PREFIX
echo "export PATH=$PATH:$PREFIX/bin"
export PATH=$PATH:$PREFIX/bin

echo "cd /etc/profile.d/"
cd /etc/profile.d/
echo "rm anaconda.sh"
rm anaconda.sh
echo "wget https://raw.githubusercontent.com/jhover/dcde/master/etc/anaconda.sh"
wget https://raw.githubusercontent.com/jhover/dcde/master/etc/anaconda.sh

# Update anaconda 
echo "conda update -y -n base -c defaults conda"
conda update -y -n base -c defaults conda

echo "conda install python=3.6 conda-manager"
conda install python=3.6 conda-manager

echo "conda update conda python"
conda update conda python

echo "conda install -c conda-forge"
conda install -c conda-forge

# Install JupyterHub
#conda install python=3.6 conda-manager

echo "conda install python=3.6" 
conda install python=3.6

echo "conda update -y conda python"
conda update -y conda python

echo "conda install -y -c conda-forge jupyterhub nodejs"
conda install -y -c conda-forge jupyterhub nodejs

echo "conda activate base"
conda activate base

echo "pip install --upgrade pip"
pip install --upgrade pip

pip install git+git://github.com/bnl-sdcc/pycomanage.git --upgrade

echo "wget --output-document /usr/local/anaconda3/etc/jupyterhub https://raw.githubusercontent.com/jhover/dcde/master/etc/jupyterhub_config.py  "
wget --output-document /usr/local/anaconda3/etc/jupyterhub https://raw.githubusercontent.com/jhover/dcde/master/etc/jupyterhub_config.py



# Cleanup
echo "cd ~/tmp"
cd ~/tmp 
echo "rm -f $SETUP"
rm -f $SETUP