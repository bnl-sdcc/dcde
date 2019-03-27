#!/bin/bash
# 
# Script to install and maintain parsl for all users on system. 
# Sets it up and makes conda base environment active by default
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
conda install python=3.6 

echo "conda update -y conda python"
conda update -y conda python

echo "conda install -y -c conda-forge"
conda install -y -c conda-forge

# Install app
conda activate base

echo "pip install --upgrade pip"
pip install --upgrade pip

echo "pip install parsl"
pip install parsl

# Cleanup
echo "cd ~/tmp"
cd ~/tmp 
echo "rm -f $SETUP"
rm -f $SETUP
