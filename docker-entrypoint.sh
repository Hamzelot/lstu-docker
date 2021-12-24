#!/bin/bash
# Generate secret for lstu services
export SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Set permissions for user lstu
groupadd -g $GID -o lstu
useradd -g $UID -g lstu lstu
chown -R lstu:lstu /usr/lstu
chmod -R 700 /usr/lstu
chmod -R 600 /usr/lstu/db
chmod u+x $(find /usr/lstu/db -type d)

if [ ! -z ${LISTEN+x} ]; then 
    sed -i -e "s|# listen|listen  => \[${LISTEN}\],|" /usr/lstu/lstu.conf
fi
if [ ! -z ${BAN_WHITELIST+x} ]; then 
    sed -i -e "s|#ban_whitelist => \[\],|ban_whitelist  => \[${BAN_WHITELIST}\],|" /usr/lstu/lstu.conf
fi
if [ ! -z ${BAN_BLACKLIST+x} ]
then 
    sed -i -e "s|#ban_blacklist => \[\],|ban_blacklist => \[${BAN_BLACKLIST}\],|g" /usr/lstu/lstu.conf
fi
if [ ! -z ${MEMCACHED_SERVERS+x} ]; then 
    sed -i -e "s|# memcached_servers => \[\]|memcached_servers => \[${MEMCACHED_SERVERS}\],|" /usr/lstu/lstu.conf
fi
if [ ! -z ${PIWIK+x} ]; then 
    sed -i -e "s|#piwik => {|piwik => {${PIWIK}},|g" /usr/lstu/lstu.conf
fi

gosu lstu "$@"

while :
do
	gosu lstu tail -f ./log/production.log
done