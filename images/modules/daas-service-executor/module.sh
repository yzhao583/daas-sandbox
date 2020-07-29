#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

install_module() {
    mkdir -p ${DAAS_HOME}/s2i
    cp -v -r ${SCRIPT_DIR}/s2i/* ${DAAS_HOME}/s2i

    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch
}

install_module ${@}

unset SCRIPT_DIR
