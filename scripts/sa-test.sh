#!/bin/bash

c++ /scripts/test.cpp -o test \
    -I/work/build-opencv/install/include \
    -L/work/build-opencv/install/lib64 -lopencv_core -lopencv_videoio

export LD_LIBRARY_PATH=/work/build-opencv/install/lib64:$LD_LIBRARY_PATH
./test
