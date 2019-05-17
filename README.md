OpenCV + MediaSDK in Docker container
=====================================

### Directory layout:

- `opencv` - OpenCV sources repository (mounted to `/opencv`, read-only)
- `opencv_extra` - OpenCV extra repository (mounted to `/opencv_extra`, read-only)
- `build` - folder for OpenCV build (mounted to `/build`, main working directory, ❗all content will be removed during build❗)
- `container-for-mediasdk` - this repository
  - `scripts` - scripts directory (mounted to `/scripts`, read-only)

### How to use

Go to the `container-for-mediasdk` directory and run `./do.sh`. Docker image will be built, container with interactive shell will be started. Inside the container run:

- Run `vainfo` to make sure VA API works correctly
- Run `test_va_api` to run VA API test suite (some tests can fail though)
- Run `/scripts/test-mfx.sh` to run basic MediaSDK samples
- Run `/scripts/build.sh` to build OpenCV with MediaSDK support
- Run `/scripts/test.sh` to run OpenCV _videoio_ tests
- Run `/scripts/test-standalone.sh` to build and run standalone OpenCV application (`/scripts/test.cpp`)

### Useful environment variables

- `LIBVA_MESSAGING_LEVEL` - set to `0` to disable libva output
- `OPENCV_VIDEOIO_DEBUG` - set to `1` to enable additional messages from OpenCV _videoio_ module
- `OPENCV_LOG_LEVEL` - set to `verbose` or `debug` to print more information from OpenCV


----------------------------------------------------------------------------------------------------


##### Example of good vainfo output

```
$ vainfo
error: can't connect to X server!
libva info: VA-API version 1.5.0
libva info: va_getDriverName() returns 0
libva info: User requested driver 'iHD'
libva info: Trying to open /usr/lib/dri/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_5
libva info: va_openDriver() returns 0
vainfo: VA-API version: 1.5 (libva 2.5.0.pre1)
vainfo: Driver version: Intel iHD driver - 2.0.0
vainfo: Supported profile and entrypoints
      VAProfileNone                   : VAEntrypointVideoProc
      VAProfileNone                   : VAEntrypointStats
      VAProfileMPEG2Simple            : VAEntrypointVLD
      VAProfileMPEG2Simple            : VAEntrypointEncSlice
      VAProfileMPEG2Main              : VAEntrypointVLD
      VAProfileMPEG2Main              : VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointFEI
      VAProfileH264Main               : VAEntrypointEncSliceLP
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSlice
      VAProfileH264High               : VAEntrypointFEI
      VAProfileH264High               : VAEntrypointEncSliceLP
      VAProfileVC1Simple              : VAEntrypointVLD
      VAProfileVC1Main                : VAEntrypointVLD
      VAProfileVC1Advanced            : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointEncPicture
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline: VAEntrypointFEI
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSliceLP
      VAProfileVP8Version0_3          : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointEncSlice
      VAProfileHEVCMain               : VAEntrypointFEI
```

##### Example of good test-mfx.sh output

```
$ /scripts/test-mfx.sh
/build /build
libva info: VA-API version 1.5.0
libva info: va_getDriverName() returns 0
libva info: User requested driver 'iHD'
libva info: Trying to open /usr/lib/dri/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_5
libva info: va_openDriver() returns 0
Decoding Sample Version 8.4.27.


Input video     AVC
Output format   NV12
Input:
  Resolution    176x96
  Crop X,Y,W,H  0,0,176,96
Output:
  Resolution    176x96
Frame rate      30.00
Memory type             system
MediaSDK impl           hw
MediaSDK version        1.30

Decoding started
Frame number:  101, fps: 2239.815, fread_fps: 0.000, fwrite_fps: 0.00098
Decoding finished
libva info: VA-API version 1.5.0
libva info: va_getDriverName() returns 0
libva info: User requested driver 'iHD'
libva info: Trying to open /usr/lib/dri/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_5
libva info: va_openDriver() returns 0
Encoding Sample Version 8.4.27.

Input file format       YUV420
Output video            AVC
Source picture:
        Resolution      176x96
        Crop X,Y,W,H    0,0,176,96
Destination picture:
        Resolution      176x96
        Crop X,Y,W,H    0,0,176,96
Frame rate      30.00
Bit rate(Kbps)  112
Gop size        0
Ref dist        4
Ref number      0
Idr Interval    0
Target usage    balanced
Memory type     system
Media SDK impl          hw
Media SDK version       1.30

Processing started
Frame number: 101

Processing finished
libva info: VA-API version 1.5.0
libva info: va_getDriverName() returns 0
libva info: User requested driver 'iHD'
libva info: Trying to open /usr/lib/dri/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_5
libva info: va_openDriver() returns 0
Decoding Sample Version 8.4.27.


Input video     AVC
Output format   NV12
Input:
  Resolution    176x96
  Crop X,Y,W,H  0,0,176,96
Output:
  Resolution    176x96
Frame rate      30.00
Memory type             system
MediaSDK impl           hw
MediaSDK version        1.30

Decoding started
Frame number:  101, fps: 7053.073, fread_fps: 0.000, fwrite_fps: 0.000
Decoding finished
/build
```
