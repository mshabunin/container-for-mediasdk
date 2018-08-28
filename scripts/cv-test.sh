#!/bin/bash

# set -e

if [ ! -f /.dockerenv ] ; then
    echo "This script should be run in a Docker container"
    exit 1
fi

# set -x

SRCDIR=/work/opencv
DATADIR=/work/opencv_extra/testdata
BUILDDIR=/work/build-opencv

export LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:$LD_LIBRARY_PATH
export OPENCV_TEST_DATA_PATH=$DATADIR
export LIBVA_MESSAGING_LEVEL=0

valgrind \
$BUILDDIR/bin/opencv_test_videoio \
    --gtest_filter=*MFX*/0

# for i in $(seq 1 1000) ; do

# $BUILDDIR/bin/opencv_test_videoio \
#     --gtest_filter=videoio/Videoio_MFX.read_write_raw/33 --gtest_repeat=3
# res=$?
# if [ $res -ne 0 ] ; then
#     echo "!!"
#     echo "!!"
#     echo "!! Failed $i"
#     echo "!!"
#     echo "!!"
#     break
# else
#     echo "!!"
#     echo "!!"
#     echo "!! Passed $i"
#     echo "!!"
#     echo "!!"
# fi
#
# done

    # --gtest_shuffle

    # --gtest_repeat=10

# $BUILDDIR/bin/opencv_test_videoio \
    # --gtest_filter=Videoio_MFX.read_invalid:Videoio_MFX.write_invalid:videoio/Videoio_MFX.read_write_raw/0:videoio/Videoio_MFX.read_write_raw/1:videoio/Videoio_MFX.read_write_raw/2:videoio/Videoio_MFX.read_write_raw/3::videoio/Videoio_MFX.read_write_raw/4
