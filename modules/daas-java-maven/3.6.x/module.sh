#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    local m2_dir="${DAAS_HOME}/.m2"
    mkdir -p ${m2_dir}/repository
    cp -v -r ${SCRIPT_DIR}/m2/* ${m2_dir}
    chown -R 1001:1001 ${m2_dir}
    chmod -R 777 ${m2_dir}

    local artifacts_dir="/tmp/artifacts"
    tar xzf ${artifacts_dir}/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/share
    ln -s /usr/share/apache-maven-${MAVEN_VERSION} /usr/share/maven

    echo 'export PATH="/usr/share/maven/bin:${PATH}"' >> ${DAAS_HOME}/.bashrc
}

install_module ${@}

unset SCRIPT_DIR
