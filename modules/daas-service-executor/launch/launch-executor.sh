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

assemble_executor() {
    log_info "Building executor..."

    local app_name="${APPLICATION_NAME:-myapp}"

    local app_group_id="${APPLICATION_GROUP_ID:-org.kie.daas.application}"
    local app_group_path=$(echo ${app_group_id} | sed 's,\.,/,g')
    local app_artifact_id="${APPLICATION_ARTIFACT_ID:-${app_name}}"
    local app_version="${APPLICATION_VERSION:-1.0}"

    local kogito_version="${KOGITO_VERSION:-0.12.0}"

    local m2_dir=${DAAS_HOME}/.m2
    local apps_dir=${DAAS_HOME}/apps
    mkdir ${apps_dir}
    cd ${apps_dir}

    mvn -e \
        archetype:generate \
        -s ${m2_dir}/settings.xml \
        --batch-mode \
        -DarchetypeGroupId=org.kie.kogito \
        -DarchetypeArtifactId=kogito-quarkus-archetype \
        -DarchetypeVersion=${kogito_version} \
        -DgroupId=${app_group_id} \
        -DartifactId=${app_artifact_id} \
        -Dversion=${app_version}

    if [ "${app_artifact_id}" != "${app_name}" ]; then
        mv "${app_artifact_id}" "${app_name}"
    fi

    local app_dir=${apps_dir}/${app_name}
    cd ${app_dir}

    sed -i 's/localhost/0.0.0.0/g' ./src/main/resources/application.properties
    rm -f ./src/main/resources/*.bpmn*
    rm -f ./src/main/resources/*.dmn
    rm -f ./src/test/java/${app_group_path}/*.java
     
    cat <<EOF > ./src/main/resources/${app_name}.dmn
<dmn:definitions xmlns:dmn="http://www.omg.org/spec/DMN/20180521/MODEL/" xmlns="https://kiegroup.org/dmn/${app_name}" xmlns:di="http://www.omg.org/spec/DMN/20180521/DI/" xmlns:kie="http://www.drools.org/kie/dmn/1.2" xmlns:dmndi="http://www.omg.org/spec/DMN/20180521/DMNDI/" xmlns:dc="http://www.omg.org/spec/DMN/20180521/DC/" xmlns:feel="http://www.omg.org/spec/DMN/20180521/FEEL/" id="${app_name}" name="${app_name}" typeLanguage="http://www.omg.org/spec/DMN/20180521/FEEL/" namespace="https://kiegroup.org/dmn/${app_name}">
  <dmn:extensionElements/>
  <dmndi:DMNDI>
    <dmndi:DMNDiagram>
      <di:extension>
        <kie:ComponentsWidthsExtension/>
      </di:extension>
    </dmndi:DMNDiagram>
  </dmndi:DMNDI>
</dmn:definitions>
EOF

    mvn -e \
        dependency:resolve-plugins \
        dependency:go-offline \
        clean \
        compile \
        -f pom.xml \
        -s ${m2_dir}/settings.xml \
        --batch-mode \
        --no-transfer-progress \
        -Dcheckstyle.skip=true \
        -Dfabric8.skip=true \
        -Dfindbugs.skip=true \
        -Djacoco.skip=true \
        -Djava.net.preferIPv4Stack=true \
        -Dmaven.javadoc.skip=true \
        -Dmaven.site.skip=true \
        -Dmaven.source.skip=true \
        -Dmaven.test.skip \
        -Dpmd.skip=true \
        -DskipTests

    for ch_dir in ${apps_dir} ${m2_dir} ; do
        chown -R 1001:1001 ${ch_dir}
        chmod -R 777 ${ch_dir}
    done
}

run_executor() {
    log_info "Launching executor..."

    local m2_dir=${DAAS_HOME}/.m2
    local app_name=${APPLICATION_NAME:-myapp}
    local app_dir=${DAAS_HOME}/apps/${app_name}

    local webdav_mount_path=${WEBDAV_MOUNT_PATH:-/var/www/webdav}
    local webdav_app_dir=${webdav_mount_path}/${app_name}
    if [ ! -d "${webdav_app_dir}" ] ; then
        cp -v -r ${app_dir} ${webdav_app_dir}
    fi
    cd ${webdav_app_dir}

    # DAAS_OPTS=""
    # log_debug "exec ${JAVA_HOME}/bin/java ${SHOW_JVM_SETTINGS} ${JAVA_OPTS} ${JAVA_OPTS_APPEND} ${JAVA_PROXY_OPTIONS} ${DAAS_OPTS} -jar /path/to/todo.jar"

    mvn -e \
        quarkus:dev \
        -f pom.xml \
        -s ${m2_dir}/settings.xml \
        --batch-mode \
        --no-transfer-progress
}

#############################################

# FIXME: not sure why I have to do this...
export PATH="${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"

DAAS_EXECUTOR_ACTION="${1-run}"

if [ "${DAAS_EXECUTOR_ACTION}" = "assemble" ]; then
    assemble_executor
elif [ "${DAAS_EXECUTOR_ACTION}" = "run" ]; then
    run_executor
else
    log_error "Unrecognized DaaS Executor action: ${DAAS_EXECUTOR_ACTION}"
    exit 1
fi
