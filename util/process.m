function [v,fv,fs,u]=process(s,Fs,lm)

winSize = 60; % msec
win = ms2sampl(winSize,Fs);

% Replace NaN measurements with average along the relevant dimension.
% (script adapted from MT via MVIEW)
s = fixNaN(s);

if size(s,2)>1
    % Find the interval I over which to compute U.
    halfWin = fix(win/2);
    if length(lm)==1
        i = [max(1,lm-halfWin),min(size(s,1),lm+halfWin)];
    else
        i = [max(1,lm(2)-halfWin),min(size(s,1),lm(2)+halfWin)];
    end
    % Project signal S onto one dimension.
    u = getPC(s(i(1):i(2),:));
    sHat = proj(s,u);
else
    sHat = s;
end

% Filter signals if signal processing toolbox is installed.
try
    [b,a]=butter(6,10*(2/Fs)); % 6th order, 10 Hz cutoff
    fs = filtfilt(b,a,sHat);
    v = computeVelocity(fs,Fs);
    fv = filtfilt(ones(1,win)./win,1,v); % rectangular window moving average filter
    fv = v;
catch
    fs = sHat;
    fv = v;
end

end