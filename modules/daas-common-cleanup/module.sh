#!/bin/sh

set -e

install_module() {
    microdnf clean all
    rm -rf /var/cache/yum

    chown -R 1001:1001 ${DAAS_HOME}
}

install_module ${@}
