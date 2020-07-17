#!/bin/bash

set -e

# SCRIPT_DIR=$(dirname $0)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage() {
    echo ""
    echo "  Usage: image.sh [name] [action] [engine] [port]"
    echo ""
    echo "   name: the service name"
    echo " action: can be one of... build, shell, run, kill"
    echo " engine: default is buildah"
    echo "   port: default is 8080 for acceptor, otherwise empty"
    echo ""
    echo "Example: ./image.sh acceptor build"
    echo ""
}

main() {
    pushd "${SCRIPT_DIR}" &> /dev/null

    local service="${1}"
    local action="${2}"
    local engine="${3:-buildah}"
    local port=""

    if [ "${service}" = "" ]; then
        echo "service name required"
        usage
        return 1
    elif [ "${service}" = "acceptor" ] && [ "${port}" = "" ] ; then
        port="8080"
    fi

    local service_name="daas-${service}-service"
    local image_name="quay.io/kiegroup/${service_name}:latest"

    local desc_file="${SCRIPT_DIR}/${service_name}.yaml"
    if [ ! -f "${desc_file}" ]; then
        echo "image descriptor file '${desc_file}' does not exist"
        usage
        return 1
    fi

    local target_dir="${SCRIPT_DIR}/target/${service_name}"
    mkdir -p "${target_dir}"

    if [ "${action}" = "build" ]; then
        cekit -v --descriptor "${desc_file}" --target "${target_dir}" build "${engine}"
    elif [ "${action}" = "shell" ]; then
        if [ "${port}" = "" ]; then
            podman run -it --rm "${image_name}" /bin/bash
        else
            podman run -it -p ${port}:${port} --rm "${image_name}" /bin/bash
        fi
    elif [ "${action}" = "run" ]; then
        mkdir -p "${target_dir}"
        if [ "${port}" = "" ]; then
            podman run -dit --rm "${image_name}" > "${target_dir}/image.cid"
        else
            podman run -dit -p ${port}:${port} --rm "${image_name}" > "${target_dir}/image.cid"
        fi
        cat "${target_dir}/image.cid"
    elif [ "${action}" = "kill" ]; then
        if [ -f "${target_dir}/image.cid" ]; then
            podman kill $(cat "${target_dir}/image.cid")
        else
            echo "container id file '${target_dir}/image.cid' for image '${image_name}' does not exist"
            return 1
        fi
    else
        echo "unrecognized action"
        usage
        return 1
    fi

    popd &> /dev/null
}

main ${@}

unset SCRIPT_DIR
