**MongooseIM** is an xmpp-server from Erlang Solutions

This is a FreeBSD port skeleton for automated building and packagine of MongooseIM. (As of 6 April 2016 there are major TODO items concerning FreeBSD hier and poudriere compatability.)

*Current hier:*
*mongooseim & mongooseimctl are in /usr/local/sbin
*configs & ssl pem are in /usr/local/etc/mongooseim
*logs are in /var/log/mongooseim
*Mnesia dbs should be in /var/db/mongooseim but ARE NOT.
*They are in /usr/local/lib/mongooseim along with all other dependencies.

*Patches (found in files directory):*
*Patched rebar.config to use [my FreeBSD fork of exml](https://github.com/thomaslegg/exml).
*Patched various scripts to use /bin/sh instead of /bin/bash
*Patched various scripts to use above hier instead of everything under one directory.

To use:
On a FreeBSD box, you should be able to clone the files into /usr/ports/local/mongooseim and then type make. (NOTE: A change in /usr/ports/Mk/bsd.port.mk has made the /usr/ports/local an unapproved category, so you'll need to add local to the list of VALID_CATEGORIES in that file.)