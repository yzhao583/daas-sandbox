#!/bin/bash

set -e

SCRIPT_DIR=$(dirname $0)

configure() {
    # systemctl enable nginx
    local target_dir="/opt/daas/modules/nginx"
    mkdir -p ${target_dir}
    cp ${SCRIPT_DIR}/launch.sh ${target_dir}
    chmod 700 ${target_dir}/launch.sh
}

configure ${@}
