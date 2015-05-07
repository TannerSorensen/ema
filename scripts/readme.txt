directory name: LANDMARKS
created on: Nov 18, 2014
created by: Tanner Sorensen
last updated: Jan 9, 2014

Dependencies:

Known dependencies include the Symbolic Math Toolbox (whose functions are called in FINDSKEWNESS), the Statistics Toolbox, and the Signal Processing Toolbox.

Demo scripts:

landmark_finder_main.m - a demo for FINDLANDMARKS.
analyzeTypeDemo.m - a demo for ANALYZETYPE.

data: a subdirectory containing data files for the above two demo scripts.

The following data file is for LANDMARK_FINDER_MAIN.M
bulha_01_0005.mat

The following three data files are for ANALYZETYPEDEMO.M
CC_1_1_0_bulha_01_0007.mat
CC_1_1_0_bulha_02_0013.mat
CC_1_1_0_bulha_03_0014.mat


util: a subdirectory containing matlab scripts.

analyzeType.m - main function for analyzing a set of movement traces.
analyzeMat.m - wrapper function for FINDLANDMARKS.
findLandmarks.m - a function which finds landmarks on a movement trace from a .mat file.
vTanEdges.m - an internal function for finding interval edges with a tangent line method
vThreshEdges.m - an internal function for finding the interval edges with a threshold method.
findSkewness.m - an internal function for finding skewness.

This subdirectory contains the following downloaded open source scripts.

linlinintersect.m - a function gotten from MATLAB Central for finding the intersection of two points. It is called by vTanEdges to find zero-crossings.
derivative.m - a function for estimating the finite differences of the vector while preserving the length of the input vector in the output vector. It uses interpolation to do this.