#!/bin/bash

set -e

launch() {
    # /usr/bin/systemctl start nginx
    /usr/sbin/nginx
    while true; do sleep 1000; done
}

launch ${@}
