#!/bin/sh

set -e

configure() {
    microdnf clean all
    rm -rf /var/cache/yum

    chown -R 1001:0 ${DAAS_HOME}
}

configure ${@}
