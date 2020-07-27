#!/bin/sh

set -e

install_module() {
    microdnf clean all
    rm -rf /var/cache/yum
    chown -R 1001:0 ${DAAS_HOME} && chmod -R ug+rwx ${DAAS_HOME}
}

install_module ${@}
