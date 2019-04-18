#!/bin/env python
#
# Python script to generate new DCDE user mapfiles
# /etc/globus/globus-acct-map  (for globus ssh)
# /etc/grid-security/grid-mapfile  (for gsissh)
#
#
# ldapsearch -LLL -H ldaps://ldap.cilogon.org \
#    -D 'uid=readonly_user,ou=system,o=DCDE,o=CO,dc=cilogon,dc=org' -x \
#    -w XXXXXXXX \
#    -b 'o=DCDE,o=CO,dc=cilogon,dc=org'

PASSWORD_FILE=/etc/dcde/dcdeldappass.txt

