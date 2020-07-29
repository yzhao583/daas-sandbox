#!/bin/sh

set -e

install_module() {
    groupadd -r jboss -g 185 && \
        useradd -u 185 -r -g 185 -m -d ${JBOSS_HOME} -s /sbin/nologin -c "JBoss user" ${JBOSS_USER}
    chown -R 185:0 ${JBOSS_HOME} && chmod -R ug+rwx ${JBOSS_HOME}
}

install_module ${@}
