#!/bin/bash

# Assumes from the caller:
#   - $progname

echo2() {
    echo "$@" >&2
}

DIE() {
    local -r msg="$1"
    echo2 "==> $progname: error: $msg"
    exit 1
}
