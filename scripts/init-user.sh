#!/bin/bash

set -x
set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

if [ $(whoami) != "root" ] ; then
    echo "This scribt should be run by the root user"
    exit 1
fi

# Create user
groupadd -g $TEST_GID $TEST_UNAME
useradd -m -u $TEST_UID -g $TEST_GID -s /bin/bash $TEST_UNAME

# Add to video group
groupadd -g $VIDEO_GID cvideo
usermod -a -G cvideo $TEST_UNAME

# Allow access to MediaSDK
chown -R $TEST_UNAME $MFX_HOME
