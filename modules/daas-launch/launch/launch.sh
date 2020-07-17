#!/bin/sh

set -e

launch() {
    local cmd_file="${DAAS_HOME}/launch/launch.cmd"
    if [ -f "${cmd_file}" ] ; then
        while IFS="" read -r cmd || [ -n "${cmd}" ] ; do
            eval "${DAAS_HOME}/launch/${cmd}"
        done < ${cmd_file}
    fi
}

launch ${@}
