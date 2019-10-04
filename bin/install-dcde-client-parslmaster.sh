#!/bin/bash -e
# 
# Script to install and maintain parsl for all users on system. 
#
#  python 3.6
#  parsl
#  oauth-ssh
#
#  BNL prefix:   /direct/sdcc+u/dcde1000001   ~dcde1000001
#  ANL prefix:   /lcrc/project/DCDE
#  ORNL prefix:  /nfs/sw

PREFIX=unset
ENV=unset

BNL=/direct/sdcc+u/dcde1000001   
ANL=/lcrc/project/DCDE
ORNL=/nfs/sw

DATE=`date +"%Y%m%d"`

#!/bin/bash
set -e
set -u
set -o pipefail

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
shift "$(($OPTIND -1))"

echo "site is $SITE"
if [[ "$SITE"=="bnl" ]] ; then 
    PREFIX=$BNL
    ENV=$BNL/$DATE
fi
if [[ "$SITE"=="anl" ]] ; then 
    PREFIX=$ANL
    ENV=$ANL/$DATE
fi
if [[ "$SITE"=="ornl" ]] ; then 
    PREFIX=$ORNL
    ENV=$ORNL/$DATE
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


