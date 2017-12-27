FROM opensuse:42.3

ARG UNAME=test
ARG UID
ARG GID
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME
RUN usermod -a -G video $UNAME

RUN zypper install -y \
    git \
    gcc \
    gcc-c++ \
    cmake \
    make \
    autoconf \
    automake \
    libtool \
    libXfixes-devel \
    libXext-devel \
    libdrm-devel \
    libpciaccess-devel \
    which

    # Mesa-libGL-devel \

#============== Building ============

RUN mkdir -p /build
WORKDIR /build

# Build libva and other libraries

RUN echo "Building libva..." && \
    git clone https://github.com/01org/libva && \
    cd libva && \
    ./autogen.sh && \
    ./configure --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib64 && \
    make -j8 install

# Build vainfo and test_libva tools

RUN echo "Building libva-utils..." && \
    git clone https://github.com/01org/libva-utils && \
    cd libva-utils && \
    ./autogen.sh && \
    ./configure --enable-tests --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib64 && \
    make -j8 install

# Build either intel-vaapi-driver ...

RUN echo "Building intel-vaapi-driver..." && \
    git clone https://github.com/01org/intel-vaapi-driver && \
    cd intel-vaapi-driver && \
    ./autogen.sh && \
    ./configure --enable-tests --enable-x11 --enable-drm --prefix=/usr --libdir=/usr/lib64 && \
    make -j8 install

# ... or media_driver

# RUN echo "Buidling media_driver..." && \
#     git clone https://github.com/intel/media-driver && \
#     git clone https://github.com/intel/gmmlib && \
#     mkdir build-media-driver && \
#     cd build-media-driver && \
#     cmake ../media-driver \
#         -DCMAKE_BUILD_TYPE=Release \
#         -DCMAKE_INSTALL_PREFIX=/usr \
#         -DCMAKE_INSTALL_LIBDIR=lib64 \
#         -DLIBVA_DRIVERS_PATH=/usr/lib64/dri \
#         -DMEDIA_VERSION="2.0.0" \
#         -DBUILD_ALONG_WITH_CMRTLIB=1 \
#         -DBS_DIR_GMMLIB=`pwd`/../gmmlib/Source/GmmLib/ \
#         -DBS_DIR_COMMON=`pwd`/../gmmlib/Source/Common/ \
#         -DBS_DIR_INC=`pwd`/../gmmlib/Source/inc/ \
#         -DBS_DIR_MEDIA=`pwd`/../media-driver && \
#     make -j8 install
#
# ENV LIBVA_DRIVERS_PATH /usr/lib64/dri
# ENV LIBVA_DRIVER_NAME iHD

# Build MediaSDK

RUN \
    git clone https://github.com/Intel-Media-SDK/MediaSDK && \
    cd MediaSDK && \
    export MFX_HOME=`pwd` && \
    perl tools/builder/build_mfx.pl --cmake=intel64.make.release --no-warn-as-error && \
    make -j8 -C __cmake/intel64.make.release install

VOLUME /work
USER $UNAME
WORKDIR /work/

CMD /bin/bash
