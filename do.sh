#!/bin/bash

set -e

IMG=msdk-build-gst
CNT=msdk-gst-container
DFILE=Dockerfile

docker build \
    -t $IMG \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    - < $DFILE

docker stop $CNT && docker rm $CNT

docker run  \
    -it \
    --name $CNT \
    -e http_proxy \
    -e https_proxy \
    --volume $(readlink -f volume):/work \
    --volume $(readlink -f scripts):/scripts:ro \
    --workdir /work \
    --privileged \
    $IMG \
    /bin/bash

    # --volume /lib/firmware/i915:/lib/firmware/i915:ro \
    # --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    # --env="DISPLAY" \
    # --net=host \
    # --device /dev/dri:/dev/dri \
    # --cap-add sys_ptrace \
