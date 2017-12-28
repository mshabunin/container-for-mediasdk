#!/bin/bash

mkdir volume
pushd volume
git clone --depth 1 https://github.com/opencv/opencv
git clone --depth 1 https://github.com/opencv/opencv_extra
popd
