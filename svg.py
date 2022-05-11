from svgpathtools import svg2paths
import numpy as np

SAMPLES_PER_PX = 4


# Samples points from a single line svg
# It returns the samples of the first line of the svg
# Make sure the svg contains only one path
def getpoints(fname, numSamples):
    paths, attributes = svg2paths(fname)

    for path, attr in zip(paths, attributes):
        myPathList = []
        for i in range(numSamples):
            myPathList.append(path.point(i / (numSamples - 1)))
        return myPathList
