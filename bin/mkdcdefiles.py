#!/bin/env python
#
# Python script to generate new DCDE user mapfiles
# /etc/globus/globus-acct-map  (for globus ssh)
#
# ldapsearch -LLL -H ldaps://ldap.cilogon.org \
#    -D 'uid=readonly_user,ou=system,o=DCDE,o=CO,dc=cilogon,dc=org' -x \
#    -w XXXXXXXX \
#    -b 'o=DCDE,o=CO,dc=cilogon,dc=org'
#
#
import ldap
import logging

PASSWORD_FILE="/etc/dcde/dcdeldappass.txt"
LDAPHOST=unicode('ldap.cilogon.org')
LDAPBASE=unicode('o=DCDE,o=CO,dc=cilogon,dc=org')
LDAPWHO=unicode('uid=readonly_user,ou=system,o=DCDE,o=CO,dc=cilogon,dc=org')
LDAPFILTERSTR= unicode('(objectClass=person)')

def read_password(password_file=PASSWORD_FILE):
	f = open(PASSWORD_FILE)
	p = f.readlines()[0]
	p = unicode(p.strip())
	logging.debug("Got password from file...")
	return p

def dcde_ldap_query(password=None):
	#
	#search_s(base, scope[, filterstr='(objectClass=*)'[, attrlist=None[, attrsonly=0]]])
	#
	logging.debug("Initializing host %s" % LDAPHOST)
	l = ldap.initialize('ldaps://%s' % LDAPHOST, bytes_mode=False)
	logging.debug("Binding...")
	l.simple_bind_s(LDAPWHO, password) 
	logging.debug("Peforming search...")
	r = l.search_s(LDAPBASE,ldap.SCOPE_SUBTREE,LDAPFILTERSTR)
	userdict = {}
	
	for dn,entry in r:
		try:
			eppn = entry['eduPersonPrincipalName'][0].strip().lower()
			logging.debug('Processing %s %s' % (dn , entry['eduPersonPrincipalName']))
			dcdid = parse_dn(dn)
			#print("%s %s") % (eppn, dcdid) 
			userdict[eppn] = dcdid.lower()
			#handle_ldap_entry(entry)
		except:
			print("Error while handling %s" % dn)

	return userdict

def parse_dn(dn):
	dnlist = dn.split(',')
	enentry = dnlist[0]
	fields = enentry.split('=')
	dcdid = fields[1].strip()
	logging.debug('Got dcdid %s' % dcdid )
	return dcdid


if __name__ == '__main__':
	logging.getLogger().setLevel(logging.DEBUG)
	p = read_password()
	d = dcde_ldap_query(p)
	print(d)
	
	

