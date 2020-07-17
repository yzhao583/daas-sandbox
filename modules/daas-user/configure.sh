#!/bin/sh

set -e

configure() {
    groupadd -r daas -g 1001 && useradd -u 1001 -r -g 1001 -m -d ${DAAS_HOME} -s /sbin/nologin -c "DaaS user" ${USER}
    chown -R 1001:0 ${DAAS_HOME}
}

configure ${@}
