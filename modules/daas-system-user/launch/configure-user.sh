#!/usr/bin/env bash

configure() {
    if [ -w /etc/passwd ]; then
        cp /etc/passwd /tmp/passwd
        sed -i "/^daas/s/[^:]*/$(id -u)/3" /tmp/passwd
        sed -i "/^daas/s/[^:]*/$(id -g)/4" /tmp/passwd
        cat /tmp/passwd > /etc/passwd
        rm /tmp/passwd
    fi
}
