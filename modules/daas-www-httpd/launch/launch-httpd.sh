#!/usr/bin/env bash

set -e

# import
source ${DAAS_HOME}/launch/logging.sh

# debug
if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    log_debug "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
fi

# config (any configurations script that needs to run on image startup must be added here)
# CONFIGURE_SCRIPTS=(
# )
# source ${KOGITO_HOME}/launch/configure.sh
#############################################

log_info "Launching httpd..."
/usr/sbin/httpd

http_ok() {
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${HTTP_PORT:-8080}/")
    if [ "${http_code}" = "200" ]; then
        return 0
    else
        log_error "http response code is ${http_code}"
        return 1
    fi
}

while $(http_ok) ; do
    sleep 1000
done
