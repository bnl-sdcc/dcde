#!/bin/bash
# 
# Script to install and maintain a comanage-enabled Jupyterhub service.   
#
SETUP="Anaconda3-5.3.1-Linux-x86_64.sh"
PREFIX="/usr/local/anaconda3"

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

#echo "cd /etc/profile.d/"
#cd /etc/profile.d/
#echo "rm anaconda.sh"
#rm anaconda.sh
#echo "wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/anaconda.sh"
#wget https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/anaconda.sh


# Update anaconda 
echo "conda update -y -n base -c defaults conda"
conda update -y -n base -c defaults conda

echo "conda install python=3.7 "
conda install python=3.7 

echo "conda update conda python"
conda update conda python

echo "conda install -y -c conda-forge jupyterhub nodejs"
conda install -y -c conda-forge jupyterhub nodejs

echo ". /usr/local/anaconda3/etc/profile.d/conda.sh "
. /usr/local/anaconda3/etc/profile.d/conda.sh

echo "conda activate base"
conda activate base

echo "pip3 install --upgrade pip"
pip3 install --upgrade pip

echo "pip3 install git+git://github.com/bnl-sdcc/pycomanage.git --upgrade "
pip3 install git+git://github.com/bnl-sdcc/pycomanage.git --upgrade

echo "wget --output-document /usr/local/anaconda3/etc/jupyterhub/jupyterhub_config.py https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/jupyterhub_config.py  "
wget --output-document /usr/local/anaconda3/etc/jupyterhub/jupyterhub_config.py https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/jupyterhub_config.py

echo "wget --output-document /etc/systemd/system/jupyterhub.service https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/jupyterhub.service  "
wget --output-document /etc/systemd/system/jupyterhub.service https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/jupyterhub.service


# Cleanup
echo "cd ~/tmp"
cd ~/tmp 
echo "rm -f $SETUP"
rm -f $SETUP

echo "1 You must now register your instance with COManage. Contact jhover@bnl.gov with information about your instance/hostname.  "
echo "   client_id and client_secret values MUST be set in /usr/local/anaconda3/etc/jupyterhub/jupyterhub_config.py "
echo ""
echo "2 You must get a valid SSL host certificate. Place cert and key files at /usr/local/anaconda3/etc/jupyterhub/ssl/[certificate.crt|key.pem] " 
echo ""
echo ""
echo "3 Ensure /etc/globus/globus-acct-map from https://dev.racf.bnl.gov/dist/dcde/globus-acct-map is current." 
echo "  Another option is to enable automatic download by running fetchdcdefiles.sh from cron. See "
echo "     https://raw.githubusercontent.com/bnl-sdcc/dcde/master/bin/fetchdcdefiles.sh  "
echo "     https://raw.githubusercontent.com/bnl-sdcc/dcde/master/etc/fetchdcdefiles.cron "
echo ""
echo "4 Ensure port 3000 is open inbound to the host, and other ports are not." 
echo ""
echo "5 To enable service run systemctl enable jupyterhub.service "
echo ""
echo "6 To start service run systemctl start jupyterhub.service "
echo "Done"
