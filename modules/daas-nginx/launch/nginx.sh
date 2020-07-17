#!/bin/sh

set -e

source ${DAAS_HOME}/launch/logging.sh

start() {
    log_info "Launching NGINX..."
    /usr/sbin/nginx -c ${DAAS_HOME}/launch/nginx.conf
}

start ${@}
