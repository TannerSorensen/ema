function [le,lev,tpv,pv,re,rev,u,vp,lambda] = findLandmarks(x, srate, tpvGuess, vargin)
% findLandmarks - find sample at which peak velocity occurs and delimit the
% left and right edges of an interval.
% 
% usage examples: 
%   (1) return all arguments, default parameters: 
%   >> [le,lev,tpv,pv,re,rev] = findLandmarks(x, srate, tpvGuess, vargin)
%   (2) return time points only, lower THRESHOLD to 0.1
%   >> [le,~,tpv,~,re,~] = findLandmarks(x, srate, tpvGuess, {0.1})
%   (3) lower THRESHOLD to 0.1, higher MPHSCALAR
%   >> [le,~,tpv,~,re,~] = findLandmarks(x, srate, tpvGuess, {0.1,[],0.8})
%   (4) custom FWIN
%   >> [le,~,tpv,~,re,~] = findLandmarks(x, srate, tpvGuess, {[],5})
% A note on usage: cell array VARGIN can be specified without empty indices
% [] only when no argument index is intended to be skipped which is less
% than the maximum filled index.
% 
% Input:
% X - an Nx2 array representing a curve in two dimensional space 
%   parametrized by t. Units are millimeters.
% SRATE - sample rate, reciprocal of sampling frequency
% TPVGUESS - a guess at the time point of peak velocity in the interval 
%   [t(1),t(end)]
% VARGIN - optional arguments, given as a cell array. Array contents by
%   index:
%   (1) THRESHOLD - velocity threshold for delimiting the interval. 
%         The value of THRESHOLD is the percent of peak velocity PV such 
%         that LE is the last sample below MINIMUM+THRESHOLD*(PV-MINIMUM),  
%         before TPV and RE is the first sample below this same threshold 
%         after TPV, where MINIMUM is a minimum velocity found to the left 
%         and right of TPV.
%         This argument is ignored when ~strcmp(method,'threshold').
%         The default value of THRESHOLD is 0.2.
%   (2) FWIN - parameter for window size in the rectangular moving average
%   filter. 
%         The default value of FWIN is SRATE/20.
%   (3) MPHSCALAR - a velocity threshold for identifying LE and RE.
%         The value of MPHSCALAR is a numer in the interval (0,1] such that 
%         the value of the filtered signal at the initial estimates of the 
%         indices of LE and RE is not greater than the quantity 
%         MPHSCALAR*PV.
%   (4) METHOD - method of finding LE and RE
%         If strcmp(method,'threshold'), then LE and RE are found using
%         VTHRESHEDGES. If strcmp(method,'tan'), then the LE and RE are
%         found using VTANEDGES. See the documentation of these functions
%         for details.
%   (5) PREPROC - preprocessing of signal
%         If strcmp(preproc,'none'), do nothing. If
%         strcmp(preproc,'pcaProj'), then project X down onto the principal
%         component of X over the interval
%         [TPVGUESS-PCAWIN,TPVGUESS+PCAWIN].
%   (6) PCAWIN - size of window in msec over which the principal component
%   of X is computed. Arument ignored if ~strcmp(PREPROC,'pcaProj').
%   (7) MINPV - minimum peak velocity which is acceptable in cm/sec. By
%   default, minPV==5;
% 
% Output:
% LE - time point in msec delimiting the left edge
% LEV - velocity at RE in cm/sec
% TPV - time point in msec of peak velocity
% PV - peak velocity in cm/sec
% RE - time point in msec delimiting the right edge
% REV - velocity at RE in cm/sec
% U - principal component vector. Empty if ~strcmp(preproc,'pcaProj').
% 
% A sketch of the algorithm: 
%   (1) Find peak velocity of a filtered signal. This gives an estimate of
%   the landmark TPV which is unaffected by negligible maxima.
%   (2) Find peak velocity of the original signal using the estimate from
%   the filtered signal as a guide. (This yields output TPV, PV)
%   (3) Find left and right edges LE,RE using the algorithm specified in
%   METHOD (default 'threshold').
% 
% TS, June 2014

% Setup
if nargin < 3 || nargin > 4,
	eval('help findLandmarks');
	return;
elseif nargin == 3
    threshold = 0.2;
    fWin = srate ./ 20; % filter window
    mphScalar = 0.6;
    method = 'threshold';
    preproc = 'none';
    pcaWin = 80;
elseif nargin == 4
    if iscell(vargin) && length(vargin)<8
        n_opt_args = length(vargin);
        if n_opt_args == 7
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = vargin{3};
            method = vargin{4};
            preproc = vargin{5};
            pcaWin = vargin{6};
            minPV = vargin{7};
        elseif n_opt_args == 6
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = vargin{3};
            method = vargin{4};
            preproc = vargin{5};
            pcaWin = vargin{6};
            minPV = [];
        elseif n_opt_args == 5
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = vargin{3};
            method = vargin{4};
            preproc = vargin{5};
            pcaWin = 80;
            minPV = 5;
        elseif n_opt_args == 4
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = vargin{3};
            method = vargin{4};
            preproc = [];
            pcaWin = [];
            minPV = [];
        elseif n_opt_args == 3
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = vargin{3};
            method = [];
            preproc = [];
            pcaWin = [];
            minPV = [];
        elseif n_opt_args == 2
            threshold = vargin{1};
            fWin = vargin{2};
            mphScalar = [];
            method = [];
            preproc = [];
            pcaWin = [];
            minPV = [];
        elseif n_opt_args == 1
            threshold = vargin{1};
            fWin = [];
            mphScalar = [];
            method = [];
            preproc = [];
            pcaWin = [];
            minPV = [];
        end
        if isempty(threshold), threshold = 0.2; end
        if isempty(fWin), fWin = srate ./ 20; end
        if isempty(mphScalar), mphScalar = 0.6; end
        if isempty(method), method = 'threshold'; end
        if isempty(preproc), preproc = 'none'; end
        if isempty(pcaWin), pcaWin = 80; end
        if isempty(minPV), minPV = 5; end
    else
        eval('help findLandmarks');
        error('Error: wrong optional arguments specification.');
    end
end
tpvGuess = ms2sampl(tpvGuess,srate);
u = [];

% Do any specified preprocessing.
if strcmp(preproc,'pcaProj')
    [x,u,lambda] = pcaProj(x,tpvGuess,srate,pcaWin);
else
    lambda = [];
end

% take derivative
x_t=zeros(size(x,1),1);
for i=1:size(x,2)
    x_t=x_t+central_diff(x(:,i),1).^2;
end
x_t = mmsec2cmsec(sqrt(x_t),srate);
% filter signal with a rectangular moving average
fx_t = filtfilt(ones(1,fWin)./fWin,1,x_t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% peak velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find peak velocity of filtered signal
[~,pks] = findpeaks(fx_t);
if isempty(pks)
    error('Error: resultant velocity is approximately monotonic.');
end
pvGuess = 0;
try
    iter=1;
    while pvGuess < minPV
        if iter>1, pks(tpvGuess) = []; end
        [~,tpvGuess] = min(abs(pks-tpvGuess));
        pvGuess = fx_t(pks(tpvGuess));
        iter = iter+1;
    end
catch e
    fprintf(1,'\nError in function FINDLANDMARKS. Lower MINPV in VARGIN.\n');
end
tpvGuess = pks(tpvGuess);
% find peak velocity of unfiltered signal nearest that of the filtered
% signal
[~,pks] = findpeaks(x_t);
[~,tpv] = min(abs(pks-tpvGuess));
pv = 0;
try
    iter = 1;
    while pv < minPV
        if iter > 1, pks(tpv) = []; end
        [~,tpv] = min(abs(pks-tpvGuess));
        pv = x_t(pks(tpv));
        iter = iter+1;
    end
catch e
    fprintf(1,'\nError in function FINDLANDMARKS. Lower MINPV in VARGIN.\n');
end
% In case the closest peak in x_t is the smaller peak of a two peak
% velocity profile, find the right peak. We search over a 30 ms window
% around pks(tpv).
for i = 1:length(pks)
    if abs(pks(tpv)-pks(i)) < ms2sampl(15,srate) && x_t(pks(tpv)) < x_t(pks(i))
        tpv = i;
    end
end
% We now have an estimate of peak velocity.
pv = x_t(pks(tpv));
tpv = pks(tpv);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% left and right edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(method,'threshold')
    [le,re] = vThreshEdges(fx_t,x_t,tpvGuess,pvGuess,tpv,pv,mphScalar,threshold,fWin);
elseif strcmp(method,'tan')
    [le,re] = vTanEdges(fx_t,x_t,tpvGuess,pvGuess,tpv,pv,mphScalar,fWin);
else
    error('Error: argument METHOD to function FINDLANDMARKS must either be ''threshold'' or ''tan''');
end
lev = x_t(le);
rev = x_t(re);
vp = x_t(le:re);
hook = central_diff(vp,1);
if strcmp(preproc,'pcaProj'), disp = x(le:re)-x(le); else disp = []; end

end