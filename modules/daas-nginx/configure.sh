#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

configure() {
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch
    echo "nginx.sh" >> ${DAAS_HOME}/launch/launch.cmd

    local log_dir="/var/log/nginx"
    mkdir -p ${log_dir}
    chown 1001:1001 ${log_dir}
}

configure ${@}

unset SCRIPT_DIR
