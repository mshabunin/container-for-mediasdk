#!/bin/bash

set -e
set -x

IMG=msdk-build
DFILE=Dockerfile

export http_proxy="http://$http_proxy"
export https_proxy="https://$https_proxy"

docker build \
    -t $IMG \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    - < $DFILE

docker run \
    --interactive --tty --rm \
    --volume $(readlink -f volume):/work \
    --env http_proxy="$http_proxy" \
    --env https_proxy="$https_proxy" \
    --privileged \
    $IMG \
    /bin/bash
