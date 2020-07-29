#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    mkdir -p ${DAAS_HOME}/www
    cp -v -r ${SCRIPT_DIR}/www/* ${DAAS_HOME}/www

    local log_dir="/var/log/nginx"
    mkdir -p ${log_dir}
    chown -R 1001:0 ${log_dir} && chmod -R ug+rwx ${log_dir}
}

install_module ${@}

unset SCRIPT_DIR
