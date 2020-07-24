#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    mkdir -p /var/www/html
    cp -v -r ${SCRIPT_DIR}/www/* /var/www/html
    mkdir -p /var/www/webdav

    mkdir -p /etc/httpd/conf.d
    cp -v -r ${SCRIPT_DIR}/conf.d/* /etc/httpd/conf.d

    for http_dir in /etc/httpd /var/www /var/log/httpd /var/run/httpd /run/httpd ; do
        chown -R ${USER}:${USER} ${http_dir}
        chmod -R 775 ${http_dir}
    done

    # usermod -aG apache ${USER}

    local http_host="${HTTP_HOST:-localhost}"
    local http_port="${HTTP_PORT:-8080}"
    local http_conf="/etc/httpd/conf/httpd.conf"

    sed -i "s/Listen 80/Listen ${http_port}/g" "${http_conf}"
    sed -i "s/#User apache/User ${USER}/g" "${http_conf}"
    sed -i "s/#Group apache/Group ${USER}/g" "${http_conf}"
    sed -i "s/#ServerName www.example.com:80/ServerName ${http_host}:${http_port}/g" "${http_conf}"
}

install_module ${@}
