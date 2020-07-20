#!/bin/sh

set -e

install_module() {
    rpm -i https://download.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
}

install_module ${@}
