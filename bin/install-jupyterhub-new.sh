
export PATH=$PATH:$PREFIX/bin
PREFIX="/usr/local/anaconda3"
export  PREFIX="/usr/local/anaconda3"
conda install -y python=3.7
conda install -y jupyterhub nodejs
pip install oauthenticator
pip install git+https://github.com/bnl-sdcc/pycomanage.git
openssl rand -hex 32
https://raw.githubusercontent.com/bnl-sdcc/dcde-config/master/etc/jupyterhub_config_comanage.py
https://raw.githubusercontent.com/bnl-sdcc/dcde-config/master/bin/fetchdcdefiles.sh
https://raw.githubusercontent.com/bnl-sdcc/dcde-config/master/etc/fetchdcdefiles.cron
https://raw.githubusercontent.com/bnl-sdcc/dcde-config/master/etc/jupyterhub.service