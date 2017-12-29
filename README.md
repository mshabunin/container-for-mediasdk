MediaSDK in Docker container
============================

- `./init.sh` - creates _volume_ directory and clones _opencv_ and _opencv_extra_ there
- `./do.sh` - builds a Docker image, creates a container and starts interactive shell inside it

Inside the container:
- `vainfo` - shows information about VA API
- `test_va_api` - runs VA API tests
- `/scripts/va-test.sh` - performs basic MediaSDK test
- `/scripts/build.sh` - builds OpenCV with MediaSDK support
- `/sctipts/cv-test.sh` - runs OpenCV _videoio_ test to verify MediaSDK support
