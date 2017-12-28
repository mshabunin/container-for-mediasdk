#!/bin/bash

set -e
set -x

IMG=msdk-build-centos
CNT=msdk-container
DFILE=Dockerfile

export http_proxy="http://$http_proxy"
export https_proxy="https://$https_proxy"

docker build \
    -t $IMG \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    - < $DFILE

docker stop $CNT && docker rm $CNT

docker run  \
    -it -d \
    --name $CNT \
    --volume $(readlink -f volume):/work \
    --volume $(readlink -f scripts):/scripts:ro \
    --workdir /work \
    --device /dev/dri:/dev/dri \
    --cap-add sys_ptrace \
    $IMG \
    /bin/bash

docker exec -it \
    --env TEST_UNAME=test \
    --env TEST_UID=$(id -u) \
    --env TEST_GID=$(id -g) \
    --env VIDEO_GID=$(stat -c %g /dev/dri/renderD128) \
    --user root \
    $CNT \
    /scripts/init-user.sh

docker exec -it \
    --user test \
    $CNT \
    /bin/bash

docker stop $CNT && docker rm $CNT
