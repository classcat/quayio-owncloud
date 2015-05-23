#!/bin/bash

########################################################################
# ClassCat/OwnCloud Asset files
# Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved.
########################################################################

#--- HISTORY -----------------------------------------------------------
# 17-may-15 : fixed.
#-----------------------------------------------------------------------


######################
### INITIALIZATION ###
######################

function init () {
  echo "ClassCat Info >> initialization code for ClassCat/OwnCloud"
  echo "Copyright (C) 2015 ClassCat Co.,Ltd. All rights reserved."
  echo ""
}


############
### SSHD ###
############

function change_root_password() {
  if [ -z "${ROOT_PASSWORD}" ]; then
    echo "ClassCat Warning >> No ROOT_PASSWORD specified."
  else
    echo -e "root:${ROOT_PASSWORD}" | chpasswd
    # echo -e "${password}\n${password}" | passwd root
  fi
}


function put_public_key() {
  if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "ClassCat Warning >> No SSH_PUBLIC_KEY specified."
  else
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
    echo "${SSH_PUBLIC_KEY}" > /root/.ssh/authorized_keys
  fi
}


#############
### MYSQL ###
#############

function config_mysql () {
  mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql -e "CREATE DATABASE ${MYSQL_OC_DBNAME}"
  mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql -e "CREATE USER '${MYSQL_OC_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_OC_PASSWORD}';"
  mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql -e "GRANT ALL ON ${MYSQL_OC_DBNAME}.* TO '${MYSQL_OC_USERNAME}'@'%'"
}


################
### OwnCloud ###
################

function config_owncloud () {
  mkdir -p ${OC_DATA_PATH}
  chown -R www-data.www-data ${OC_DATA_PATH}
}


##################
### SUPERVISOR ###
##################
# See http://docs.docker.com/articles/using_supervisord/

function proc_supervisor () {
  cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[program:ssh]
command=/usr/sbin/sshd -D

[program:apache2]
command=/usr/sbin/apache2ctl -D FOREGROUND

[program:rsyslog]
command=/usr/sbin/rsyslogd -n
EOF
}


### ENTRY POINT ###

init 
change_root_password
put_public_key
config_mysql
config_owncloud
proc_supervisor

exit 0


### End of Script ###
