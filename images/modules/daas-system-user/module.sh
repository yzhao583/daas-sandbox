#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    groupadd -r daas -g 1001 && \
        useradd -u 1001 -r -g 1001 -G 0 -m -d ${DAAS_HOME} -s /sbin/nologin -c "DaaS user" ${DAAS_USER}
    chown -R 1001:0 ${DAAS_HOME} && chmod -R ug+rwx ${DAAS_HOME}

    chmod g=u /etc/passwd
}

install_module ${@}

unset SCRIPT_DIR
