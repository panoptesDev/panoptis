#!/usr/bin/env bash
set -ex

[[ $(uname) = Linux ]] || exit 1
[[ $USER = root ]] || exit 1

# Install libssl-dev to be compatible with binaries built on an Ubuntu machine...
apt-get update
apt-get --assume-yes install libssl-dev

# Install libssl1.1 to be compatible with binaries built in the
# solanalabs/rust docker image
#
# cc: https://github.com/panoptisdev/panoptis/issues/1090
apt-get --assume-yes install libssl1.1
