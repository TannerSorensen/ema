function [le,re] = edges(s,Fs,tpv)
% VTHRESHEDGES - Find the minima to the left and right of tpv in the 
%   filtered signal. This gives landmarks for the left and right edges 
%   which are unaffected by negligible minima.
% 
% Replaced vecRev with vecRev. This eliminates the Wavelet Toolbox
% dependency, TS, December 2014.
% Moved to util2 and made compatible with util2 system, TS, May 2015.

% Set constants.
THRESHOLD = 0.2;

% Compute velocity and filter velocity.
[~,fv]=process(s,Fs,tpv);

% Find right edge minimum.
[~,i]=findpeaks(-fv(tpv:end));
reMinInd=tpv+i(1)-1;
reThresh=fv(reMinInd) + THRESHOLD*(fv(tpv)-fv(reMinInd));

% Find left edge minimum.
[~,i]=findpeaks(-fv(1:tpv));
leMinInd=i(end);
leThresh=fv(leMinInd) + THRESHOLD*(fv(tpv)-fv(leMinInd));


% Find left and right edges.
re=tpv+find(fv(tpv:end)<reThresh,1);
le=tpv-find(vecRev(fv(1:tpv))<leThresh,1);

end