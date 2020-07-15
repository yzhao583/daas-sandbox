#!/bin/bash

set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage() {
    echo ""
    echo "  Usage: service.sh [name] [action] [engine]"
    echo ""
    echo "   name: the service name; a subdir of the services/ dir"
    echo " action: build, shell, run, kill"
    echo " engine: default is 'buildah'"
    echo ""
    echo "Example: ./service.sh acceptor build"
    echo ""
}

main() {
    local service="${1}"
    local action="${2}"
    local engine="${3:-buildah}"
    if [ "${service}" = "" ]; then
        echo "service name required"
        usage
        return 1
    fi
    local service_dir="${ROOT_DIR}/services/${service}"
    if [ ! -d "${service_dir}" ]; then
        echo "directory '${service_dir}' for service '${service}' does not exist"
        return 1
    fi
    local target_dir="${service_dir}/target"
    if [ "${action}" = "build" ]; then
        pushd "${service_dir}" &> /dev/null
        local git_url="https://github.com/$(git config github.user)/daas-sandbox.git"
        local git_ref="$(git branch --show-current)"
        cekit -v build --overrides "{'modules': {'repositories': [{'name': 'daas-sandbox', 'git': {'url': '${git_url}', 'ref': '${git_ref}'}}]}}" "${engine}"
        popd &> /dev/null
    elif [ "${action}" = "shell" ]; then
        podman run -it -p 8080:80 --rm "localhost/kiegroup/daas-${service}-service:latest" /bin/bash
    elif [ "${action}" = "run" ]; then
        mkdir -p "${target_dir}"
        podman run -dit -p 8080:80 --rm "localhost/kiegroup/daas-${service}-service:latest" > "${target_dir}/image.cid"
        cat "${target_dir}/image.cid"
    elif [ "${action}" = "kill" ]; then
        if [ -f "${target_dir}/image.cid" ]; then
            podman kill $(cat "${target_dir}/image.cid")
        else
            echo "container id file '${target_dir}/image.cid' for service '${service}' does not exist"
            return 1
        fi
    else
        echo "unrecognized action"
        usage
        return 1
    fi
}

main ${@}

unset ROOT_DIR
