#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

configure() {
    mkdir -p ${DAAS_HOME}/launch
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch

    touch ${DAAS_HOME}/launch/launch.cmd
}

configure ${@}

unset SCRIPT_DIR
