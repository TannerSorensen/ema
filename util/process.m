function [v,fv,fsHat,u,cv,fs]=process(s,Fs,lm)

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
    if sign(atan2(u(2),u(1)))==-1, u=-u; end
    sHat = proj(s,u);
else
    sHat = s;
end

%[b,a]=butter(6,10*(2/Fs)); % 6th order, 10 Hz cutoff
%fsHat = filtfilt(b,a,sHat);
fsHat = sHat;
[v,cv] = computeVelocity(sHat,Fs);
fs = s;
winSize = 20; % msec
win = ms2sampl(winSize,Fs);
fv = abs(filtfilt(ones(1,win)./win,1,cv));

end