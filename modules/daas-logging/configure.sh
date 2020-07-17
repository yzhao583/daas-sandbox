#!/bin/sh

set -e

SCRIPT_DIR=$(dirname $0)

configure() {
    cp -v -r ${SCRIPT_DIR}/launch/* ${DAAS_HOME}/launch
}

configure ${@}

unset SCRIPT_DIR
