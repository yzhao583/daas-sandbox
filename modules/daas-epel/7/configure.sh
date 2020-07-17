#!/bin/sh

set -e

configure() {
    rpm -i https://download.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
}

configure ${@}
