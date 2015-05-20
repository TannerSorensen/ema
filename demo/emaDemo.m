
% Task:
% Find the peak velocity of the /o/ constriction 
% of the vowel /o/ in the word 'go' of sentence 
% 'When can we go home'. 
iDir='../data';
iStr='.*.mat';
lmStr='pv';
an='T4';
[fl,lm] = findLandmarks(iStr,iDir,lmStr,an);

% Visualize file I over a 500 msec time window 
% around landmark LM.
% tongue (red), lip (blue), jaw (green)
try
    i=input(sprintf(['Enter file number from %d to %d '...
        'for visualization: '],1,length(fl)));
    winSize=500;
    tongue={'T1';'T2';'T3';'T4'};
    lips={'LL','UL'};
    jaw={'MNI','MNM'};
    plotLandmarks(fullfile(iDir,fl{i}),lmStr,tongue,lips,jaw,lm(i),winSize);
catch e
    error(['Error: file number must an '...
        'integer from %d to %d'],1,length(fl));
end
