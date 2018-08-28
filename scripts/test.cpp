#include "opencv2/videoio.hpp"
#include <iostream>

using namespace cv;
using namespace std;

int main()
{
    string filename = "test.mpeg2";
    Size sz(1920, 1080);
    Mat frame(sz, CV_8UC3);
    frame = 0;
    VideoWriter writer;
    writer.open(filename, CAP_INTEL_MFX, VideoWriter::fourcc('M', 'P', 'G', '2'), 30, sz, true);
    for (int i = 0; i < 3000; ++i)
        writer << frame;
    return 0;
}
