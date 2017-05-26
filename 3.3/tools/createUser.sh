#!/bin/sh
##################################################################
# add user to htpasswd files.
##################################################################
USERS="\
joe \
alice \
bob \
charlie \
david \
zulu \
victor \
"

PASSWORD="redhat"

HTPASSWD_FILE="/etc/openshift-htpasswd"


for u in $USERS; do
  htpasswd -b $HTPASSWD_FILE $u $PASSWORD;
done;

cat $HTPASSWD_FILE
