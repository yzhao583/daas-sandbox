#!/bin/sh

set -e

install_module() {
    groupadd -r jboss -g 1002 && useradd -u 1002 -r -g 1002 -m -d ${JBOSS_HOME} -s /sbin/nologin -c "JBoss user" ${JBOSS_USER}
    chown -R 1002:1002 ${JBOSS_HOME}
}

install_module ${@}
