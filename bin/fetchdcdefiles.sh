#!/bin/bash*
# Script to download DCDE mapfile(s)
#
# https://dev.racf.bnl.gov/dist/dcde/globus-acct-map -> /etc/globus/globus-acct-map
# https://dev.racf.bnl.gov/dist/dcde/grid-mapfile -> /etc/grid-security/grid-mapfile
# Run as root from cron. 
# John Hover <jhover@bnl.gov>
# 

MAPURL="https://dev.racf.bnl.gov/dist/dcde/globus-acct-map"
MAPFILE="/etc/globus/globus-acct-map"
MAPDIR=`dirname $MAPFILE`

GMAPURL="https://dev.racf.bnl.gov/dist/dcde/grid-mapfile"
GMAPFILE="/etc/grid-security/grid-mapfile"
GMAPDIR==`dirname $MAPFILE`

DATE_FMT="+%Y%m%d-%H:%M:%S"

# Ensure directory

if [ ! -d $MAPDIR ]; then
	mkdir -p $MAPDIR
	now=`date $DATE_FMT `
	echo "[ $now ] Creating $MAPDIR directory."
fi

# Backup existing. 
if [ -f "$MAPFILE" ]; then
	tempfile=`mktemp`
	cp $MAPFILE $tempfile 2> /dev/null
	now=`date $DATE_FMT `
	echo "[ $now ] Created copy at $tempfile."
fi

# Download current
newtemp=`mktemp`
wget $MAPURL -O $newtemp 2> /dev/null

if [ $? -ne 0 ]; then
	now=`date $DATE_FMT `
	echo "[ $now ] Something went wrong. wget output at $newtemp."
else
	mv $newtemp $MAPFILE  2> /dev/null
    now=`date $DATE_FMT `
	echo "[ $now ] Moved $newtemp to  $MAPFILE"
fi

# Clean up. 
if [ -f "$tempfile" ]; then
	rm -f $tempfile 2> /dev/null
	now=`date $DATE_FMT `
	echo "[ $now ] Removed backup $tempfile."
fi


