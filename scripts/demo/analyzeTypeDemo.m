% ANALYZETYPEDEMO - demonstrates the robustness of ANALYZETYPE.
% 
% Make sure that the current directory is the folder you want to write the
% output files to.
% 
% TS, Nov. 2014

% Add the subdirectories util and data to the path.
addpath(genpath('../util'));
addpath(genpath('../data'));
% The asterisk * indicates the wildcard in regular expressions. It stands
% in for other character(s).
% We analyze three bulha tokens.
%srchStr = '../data/*_bulha_*';
srchStr = '../data/*_head_*';
type = 'bulha';
subj = 'mySubj';
fileInputDir = cd;
%articulator = 't_back_pos';
articulator = 'TB';
options = {[],10,.8,'threshold','pcaProj',80};

% Select the landmark you want to analyze in the three bulha tokens. Click
% on the point you want to analyze in the bottom panel. 
% I recommend you choose the large velocity peak, which corresponds to the
% tongue body movement for the /a/ constriction.
analyzeType(srchStr, type, subj, fileInputDir, articulator, options);
