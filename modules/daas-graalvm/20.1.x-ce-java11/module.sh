#!/bin/sh

set -e

install_module() {
    local artifacts_dir="/tmp/artifacts"
    tar xzf ${artifacts_dir}/graalvm-ce-java${GRAALVM_JAVA_VERSION}-linux-amd64-${GRAALVM_VERSION}.tar.gz -C /usr/share
    ln -s /usr/share/graalvm-ce-java${GRAALVM_JAVA_VERSION}-${GRAALVM_VERSION} ${GRAALVM_HOME}

    ${GRAALVM_HOME}/bin/gu -L install ${artifacts_dir}/native-image-installable-svm-java${GRAALVM_JAVA_VERSION}-linux-amd64-${GRAALVM_VERSION}.jar

    # see #KOGITO-384
    # also note path '/lib/' below differs from 20.1.x-ce-java8, which is '/jre/lib/'
    mkdir -p ${DAAS_HOME}/ssl-libs
    cp -v ${GRAALVM_HOME}/lib/libsunec.so ${DAAS_HOME}/ssl-libs/
    cp -v ${GRAALVM_HOME}/lib/security/cacerts ${DAAS_HOME}/

    echo 'export PATH="/usr/share/graalvm/bin:${PATH}"' >> ${DAAS_HOME}/.bashrc
}

install_module ${@}
