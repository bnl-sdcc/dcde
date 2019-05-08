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
import argparse
import ldap
import logging
import os
import shutil
import tempfile
import traceback


HEADER='''# Globus map file for DCDE
# /etc/globus/globus-acct-map
# 
'''

LDAPHOST=unicode('ldap.cilogon.org')
LDAPBASE=unicode('o=DCDE,o=CO,dc=cilogon,dc=org')
LDAPWHO=unicode('uid=readonly_user,ou=system,o=DCDE,o=CO,dc=cilogon,dc=org')
LDAPFILTERSTR= unicode('(objectClass=person)')


def read_password(filepath):
	filepath = os.path.expanduser(filepath)
	logging.debug("Opening pass file %s" % filepath)
	f = open(filepath)
	p = f.readlines()[0]
	f.close()
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

def write_file(filepath, d):
	''' 
	Put dictionary in file. Write into temp file. Move to final path atomically. 
	'''
	logging.debug(d)
	filepath = os.path.expanduser(filepath)
	logging.debug("Target file path is %s" % filepath)
	try:
		tf, tfpath = tempfile.mkstemp(text=True)
		f = open(tfpath, 'w')
		logging.debug("Got tempfile %s %s" % ( tf, tfpath))
		skeys = d.keys()
		skeys.sort()
		f.write(HEADER)
		for k in skeys:
			f.write("%s %s\n" % ( k, d[k]))
		f.close()
		logging.debug("Changing mode of %s to world readable" % tfpath)
		os.chmod(tfpath, 0o444 )
		logging.debug("Moving file from %s -> %s" % (tfpath, filepath))
		shutil.move(tfpath, filepath )
		logging.info("Successfully updated %s" % filepath)

	except:
		logging.error(traceback.format_exc(None))
		#logging.error("Something went wrong writing file...")


if __name__ == '__main__':
	
	logging.basicConfig(format='%(asctime)s (UTC) [ %(levelname)s ] %(name)s %(filename)s:%(lineno)d %(funcName)s(): %(message)s')
	
	parser = argparse.ArgumentParser()
	parser.add_argument('-p', '--passfile', 
        				action="store", 
        	   			dest='passfile', 
                        default='/etc/dcde/dcdeldappass.txt',
                        help='ldap password file path.')

	parser.add_argument('-m', '--mapfile', 
        				action="store", 
        	   			dest='mapfile', 
                        default="/etc/globus/globus-acct-map",
                        help='path to write map file')	
	
	parser.add_argument('-d', '--debug', 
						action="store_true", 
						dest='debug', 
						help='debug logging')
	args= parser.parse_args()
	
	if args.debug:
		logging.getLogger().setLevel(logging.DEBUG)
	p = read_password(args.passfile)
	d = dcde_ldap_query(p)
	write_file(args.mapfile, d)
	
	

