% demo on X-ray microbeam database, task 7, EMA receiver coil T3

iDir='G:\Libraries\raw_data\UWXRMB\mat';
iStr='*TP007*';
lmStr='pv';
an='T3';

lm = findLandmarks(iStr,iDir,lmStr,an);