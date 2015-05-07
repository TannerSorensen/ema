function [le,re] = vThreshEdges(fx_t,x_t,tpvGuess,pvGuess,tpv,pv,mphScalar,threshold,fWin)
% VTHRESHEDGES - Find the minima to the left and right of TPV in the 
%   filtered signal. This gives landmarks for the left and right edges 
%   which are unaffected by negligible minima.
% 
% Replaced vecRev with vecRev. This eliminates the Wavelet Toolbox
% dependency, TS, December 2014.

% find minima around the maximum of the filtered signal
[~,leFiltMin] = findpeaks(-vecRev(fx_t(1:tpvGuess)),'MINPEAKHEIGHT',-mphScalar.*pvGuess,'NPEAKS',1);
[~,reFiltMin] = findpeaks(-fx_t(tpvGuess:end),'MINPEAKHEIGHT',-mphScalar.*pvGuess,'NPEAKS',1);
if isempty(leFiltMin) || isempty(reFiltMin)
    error('Error: resultant velocity is monotonically decreasing to the left or right of peak velocity.');
end
% find minima around the peak velocity of the unfiltered signal
[leMins,leMinIndices] = findpeaks(-vecRev(x_t(1:tpv)));
[reMins,reMinIndices] = findpeaks(-x_t(tpv:end));
if isempty(leMins) || isempty(reMins)
    error('Error: resultant velocity is monotonically decreasing to the left or right of peak velocity.');
end
[~,leMinIndex] = min(abs(leMinIndices-leFiltMin));
[~,reMinIndex] = min(abs(reMinIndices-reFiltMin));
leMin = -leMins(leMinIndex);
reMin = -reMins(reMinIndex);
% find threshold velocities which indicate the left and right edges
leThreshold = leMin + threshold.*(pv-leMin);
reThreshold = reMin + threshold.*(pv-reMin);
% find the left and right edges
le = find(vecRev(x_t(1:tpv))<=leThreshold,1);
le = tpv - le;
re = find(x_t(tpv:end)<=reThreshold,1);
re = tpv + re - 1;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % TEST
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Take derivative to get acceleration and filter it.
% x_tt = diff(x_t);
% fx_tt = filtfilt(ones(1,fWin)./fWin,1,FixNaN(x_tt));
% 
% % Find acceleration extrema in the filtered signal over the intervals 
% % [leEst,tpv] and [tpv,reEst].
% ons2pv = fx_tt(le:tpv);
% pv2offs = fx_tt(tpv:re);
% [~,accMaxIndex] = max(vecRev(ons2pv));
% [~,accMinIndex] = min(pv2offs);
% accMaxIndex = tpvGuess - accMaxIndex;
% accMinIndex = tpvGuess + accMinIndex;
% 
% % Find acceleration extrema in the unfiltered signal over the intervals 
% % [leEst,tpv] and [tpv,reEst].
% [~,accMaxIndices] = findpeaks(x_tt);
% [~,accMinIndices] = findpeaks(-x_tt);
% 
% % Take the nearest extrema to those of the filtered signal.
% [~,accMaxIndex] = min(abs(accMaxIndices-accMaxIndex));
% [~,accMinIndex] = min(abs(accMinIndices-accMinIndex));
% accMaxIndex = accMaxIndices(accMaxIndex);
% accMinIndex = accMinIndices(accMinIndex);
% accMax = x_tt(accMaxIndex);
% accMin = x_tt(accMinIndex);
% 
% % Make sure that acceleration and deceleration has not become nearly zero
% % before RE and LE are reached.
% le2aM = x_tt(le:accMaxIndex);
% lhsNullAcc = find(le2aM < threshold*accMax, 1, 'last');
% aM2re = x_tt(accMinIndex:re-1);
% rhsNullAcc = find(aM2re > threshold*accMin, 1, 'first');
% if ~isempty(lhsNullAcc), le = le + lhsNullAcc; end
% if ~isempty(rhsNullAcc), re = accMinIndex + rhsNullAcc - 1; end

end