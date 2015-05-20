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

% Find left and right edges.
re=tpv+find(fv(tpv:end)<THRESHOLD*fv(tpv),1);
le=tpv-find(vecRev(fv(1:tpv))<THRESHOLD*fv(tpv),1);

end