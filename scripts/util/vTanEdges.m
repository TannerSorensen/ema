function [le,re] = vTanEdges(fx_t,x_t,tpvGuess,pvGuess,tpv,pv,mphScalar,fWin)
% Replaced WREV with VECREV. This eliminates the Wavelet Toolbox
% dependency, TS, December 2014.

% Estimate the edges using a velocity threshold.
[leEst,reEst] = vThreshEdges(fx_t,x_t,tpvGuess,pvGuess,tpv,pv,mphScalar,0.2);

% Take derivative to get acceleration and filter it.
x_tt = diff(x_t);
fx_tt = filtfilt(ones(1,fWin)./fWin,1,x_tt);

% Find acceleration extrema in the filtered signal over the intervals 
% [leEst,tpv] and [tpv,reEst].
ons2pv = fx_tt(leEst:tpvGuess);
pv2offs = fx_tt(tpvGuess:reEst);
[~,accMaxIndex] = max(vecRev(ons2pv));
[~,accMinIndex] = min(pv2offs);
accMaxIndex = tpvGuess - accMaxIndex;
accMinIndex = tpvGuess + accMinIndex;

% Find acceleration extrema in the unfiltered signal over the intervals 
% [leEst,tpv] and [tpv,reEst].
[~,accMaxIndices] = findpeaks(x_tt);
[~,accMinIndices] = findpeaks(-x_tt);

% Take the nearest extrema to those of the filtered signal.
[~,accMaxIndex] = min(abs(accMaxIndices-accMaxIndex));
[~,accMinIndex] = min(abs(accMinIndices-accMinIndex));
accMaxIndex = accMaxIndices(accMaxIndex);
accMinIndex = accMinIndices(accMinIndex);

% Find the points on the velocity profile around these points.
maxAccV1 = [accMaxIndex-1, x_t(accMaxIndex-1)];
maxAccV2 = [accMaxIndex, x_t(accMaxIndex)];
minAccV1 = [accMinIndex-1, x_t(accMinIndex-1)];
minAccV2 = [accMinIndex, x_t(accMinIndex)];

% Fit a tangent line Lre,Lle to the velocity profile at the indices of the 
% maximum and minimum acceleration. Then find the intersections of Lre,Lle 
% with the time axis. The intersections are the edges. 
le = linlinintersect([0,0;1,0;maxAccV1;maxAccV2]);
re = linlinintersect([0,0;1,0;minAccV1;minAccV2]);

le = ceil(le(1)); re = floor(re(1));

% Now we check to see if we overshot. In particular, we make sure that
% there is no velocity minima over our interval.
[vMin,vMinLocs] = findpeaks(-x_t(le:re));
if ~isempty(vMin)
    % If there are velocity minima, divide them into those which occur
    % before and those which occur after TPV, order these, and 
    [~,minLHSInd] = sort(vMin(vMinLocs < tpv),1,'descend');
    [~,minRHSInd] = sort(vMin(vMinLocs >= tpv));
    locsLHS = vMinLocs(vMinLocs < tpv);
    locsRHS = vMinLocs(vMinLocs >= tpv);
    if ~isempty(locsLHS), minLHS = locsLHS(minLHSInd(1)); le = le + minLHS; end
    if ~isempty(locsRHS), minRHS = locsRHS(minRHSInd(1)); re = le + minRHS; end
end

end