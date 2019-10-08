#!/bin/bash -e
set -e
set -u
set -o pipefail

# 
# Script to install and maintain parsl for all users on system. 
#
#  python 3.6
#  parsl
#  oauth-ssh
#
#  BNL prefix:   /sdcc/u/dcde1000012
#  ANL prefix:   /lcrc/project/DCDE
#  ORNL prefix:  /nfs/sw

SITE=unset
PREFIX=unset
ENV=unset

BNL=/sdcc/u/dcde1000012   
ANL=/lcrc/project/DCDE
ORNL=/nfs/sw

DATE=`date +"%Y%m%d"`

while getopts 's:' OPTION; do
  case "$OPTION" in
    s)
      SITE="$OPTARG"
      echo "The value provided is $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done

echo "site is $SITE"

if [ $SITE == "bnl" ]; then 
    echo "setting up bnl"
    PREFIX="$BNL"
    ENV="$BNL/$DATE"
elif [ $SITE == "anl" ]; then 
    echo "setting up anl"
    PREFIX="$ANL"
    ENV="$ANL/$DATE"
elif [  $SITE == "ornl" ]; then 
    echo "setting up ornl"
    PREFIX="$ORNL"
    ENV="$ORNL/$DATE"
fi

echo "prefix is $PREFIX env is $ENV"

cd $PREFIX
wget https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
mkdir -p anaconda
bash Anaconda3-5.3.1-Linux-x86_64.sh -u -f -b -p ./anaconda
echo export PATH=$PREFIX/anaconda/bin:\$PATH > setup.sh
source setup.sh
conda create -y --name dcdemaster$DATE python=3.6
source activate dcdemaster$DATE
pip install git+https://www.github.com/Parsl/parsl.git
pip install oauth-ssh


