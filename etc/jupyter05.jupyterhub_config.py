#
# Customized entries for Jupyterhub using CILogon/COManage authN/AuthZ
# Requires customized comanage.py auth plugin
# John Hover <jhover@bnl.gov>
#

import os
os.environ['CILOGON_HOST'] = 'cilogon.org'
os.environ['CILOGON_CLIENT_ID'] = 'cilogon:/client_id/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
os.environ['CILOGON_CLIENT_SECRET'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx'
os.environ['JUPYTERHUB_CRYPT_KEY'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

from oauthenticator.comanage import COManageOAuthenticator, LocalCOManageOAuthenticator
from jupyterhub.comanage import COManageLocalProcessSpawner

c.JupyterHub.spawner_class = COManageLocalProcessSpawner
c.JupyterHub.authenticator_class = LocalCOManageOAuthenticator

c.COManageLocalAuthenticator.unixname_source = 'eppn_mapfile'
c.COManageLocalAuthenticator.eppn_mapfile = '/etc/globus/globus-acct-map'

c.COManageOAuthenticator.oauth_callback_url = 'https://jupyter05.sdcc.bnl.gov:8000/hub/oauth_callback'
c.COManageOAuthenticator.idp_whitelist = [ 'bnl.gov','anl.gov','ornl.gov', 'lbl.gov']
c.COManageOAuthenticator.comanage_group_whitelist = [ 'CO:members:active','bnl' ]
c.JupyterHub.cookie_secret_file = '/usr/local/anaconda3/etc/jupyterhub/jupyterhub_cookie_secret'
c.ConfigurableHTTPProxy.debug = True
c.JupyterHub.log_level = 10
c.JupyterHub.ssl_cert = '/usr/local/anaconda3/etc/jupyterhub/ssl/certificate.crt'
c.JupyterHub.ssl_key = '/usr/local/anaconda3/etc/jupyterhub/ssl/key.pem'
c.Spawner.debug = True
c.Authenticator.admin_users = {'jhover@bnl.gov'}
c.Authenticator.enable_auth_state = True
c.LocalAuthenticator.delete_invalid_users = True
c.LocalAuthenticator.create_system_users = True
