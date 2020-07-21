#!/usr/bin/env bash

set -e

# import
source ${DAAS_HOME}/launch/logging.sh

# debug
if [ "${SCRIPT_DEBUG}" = "true" ] ; then
    set -x
    SHOW_JVM_SETTINGS="-XshowSettings:properties"
    log_info "Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed"
    log_info "JVM settings debug is enabled."
fi

# config (any configurations script that needs to run on image startup must be added here)
CONFIGURE_SCRIPTS=(
    ${DAAS_HOME}/launch/configure-maven.sh
    /opt/run-java/proxy-options
)
source ${DAAS_HOME}/launch/configure.sh

#############################################

# for JVM property settings please refer to this link:
# https://github.com/jboss-openshift/cct_module/blob/master/jboss/container/java/jvm/api/module.yaml
source /usr/local/dynamic-resources/dynamic_resources.sh
JAVA_OPTS="$(adjust_java_options ${JAVA_OPTS})"

#############################################

log_info "Launching deployer..."

DAAS_OPTS=""
log_debug "exec ${JAVA_HOME}/bin/java ${SHOW_JVM_SETTINGS} ${JAVA_OPTS} ${JAVA_OPTS_APPEND} ${JAVA_PROXY_OPTIONS} ${DAAS_OPTS} -jar /path/to/todo.jar"

# TODO: replace
while true ; do
    sleep 1000
done
