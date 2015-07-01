addpath(genpath('../util'))

% Task:
% Find the peak velocity of the /o/ constriction 
% of the vowel /o/ in the word 'go' of sentence 
% 'When can we go home'. 
% 
% GUI instructions:
%   select (hotkey s) - toggle select mode. when 
%     in select mode, click axes to select a 
%     landmark time point.
%   confirm (hotkey d) - confirm selection 
%     (selection is displayed as a red dot)
%     and advance to next token.
%   slider bar - move forward or backward in 
%     time (x-axis)
%   number field - change size of visible time 
%     window (msec)
iDir='../data';
iStr='.*.mat';
lmStr='pv';
an='T4';
[fl,lm] = findLandmarks(iStr,iDir,lmStr,an,0);

% Visualize file I over a 500 msec time window 
% around landmark LM.
% tongue (red), lip (blue), jaw (green)
while ~exist('i','var') || i~=0
    i=input(sprintf(['Enter file number from %d to %d '...
        'for visualization or press 0 to exit: '],1,length(fl)));
    if i~=0
        try
            winSize=500;
            tongue={'T1';'T2';'T3';'T4'};
            lips={'LL','UL'};
            jaw={'MNI','MNM'};
            close all
            playLandmark(fullfile(iDir,fl{i}),lmStr,tongue,lips,jaw,lm(i),winSize);
        catch e
            error(['Error: file number must an '...
                'integer from %d to %d'],1,length(fl));
        end
    else
        disp('Goodbye')
    end
end


