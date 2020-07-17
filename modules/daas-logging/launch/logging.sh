#!/bin/sh

log_message() {
    local msg="${1}"
    local color="${2}"
    if [ -n "${color}" ] ; then
        echo 1>&2 -e "\033[0;${color}m${msg}\033[0m"
    else
        echo 1>&2 -e "${msg}"
    fi
}

log_debug() {
    # color: blue
    log_message "[DEBUG] ${1}" "34"
}

log_info() {
    # color: green
    log_message " [INFO] ${1}" "32"
}

log_warning() {
    # color: yellow
    log_message " [WARN] ${1}" "33"
}

log_error() {
    # color: red
    log_message "[ERROR] ${1}" "31"
}
