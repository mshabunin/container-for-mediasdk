#!/bin/bash

set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

if [ "$(whoami)" != "root" ] ; then
    echo "This script should be run by the root user"
    exit 2
fi

if [ -z "$TEST_UID" -o -z "$TEST_GID" -o -z "$TEST_UNAME" ] ; then
    echo "Please set necessary environment variables before running this script"
    exit 3
fi

set -x

# Create user
groupadd -g $TEST_GID $TEST_UNAME
useradd -m -u $TEST_UID -g $TEST_GID -s /bin/bash $TEST_UNAME

# Add to video group
groupadd -g $VIDEO_GID cvideo
usermod -a -G cvideo $TEST_UNAME
usermod -a -G cvideo root

# Allow access to MediaSDK
chown -R $TEST_UNAME $MFX_HOME
