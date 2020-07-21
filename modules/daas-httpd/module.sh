#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    mkdir -p /var/www/html
    cp -v -r ${SCRIPT_DIR}/www/* /var/www/html
    mkdir -p /var/www/webdav
    chown -R apache:apache /var/www

    mkdir -p /etc/httpd/conf.d
    cp -v -r ${SCRIPT_DIR}/conf.d/* /etc/httpd/conf.d

    sed -i "s/Listen 80/Listen 8080/g" "/etc/httpd/conf/httpd.conf"
    sed -i "s/#ServerName www.example.com:80/ServerName localhost:8080/g" "/etc/httpd/conf/httpd.conf"
}

install_module ${@}
