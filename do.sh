#!/bin/bash

set -e
set -x

IMG=msdk-build
CNT=msdk-container
DFILE=Dockerfile

docker build \
    -t $IMG \
    --build-arg http_proxy=${http_proxy} \
    --build-arg https_proxy=${https_proxy} \
    - < $DFILE

docker run  \
    -it \
    --name $CNT \
    --volume $(readlink -f scripts):/scripts:ro \
    --volume $(readlink -f ../opencv):/opencv:ro \
    --volume $(readlink -f ../opencv_extra):/opencv_extra:ro \
    --volume $(readlink -f ../build):/build \
    --workdir /build \
    --device /dev/dri:/dev/dri \
    --cap-add sys_ptrace \
    --user $(id -u):$(id -g) \
    --group-add 44 \
    --rm \
    $IMG \
    /bin/bash
