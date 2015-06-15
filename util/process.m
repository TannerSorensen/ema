function [v,fv]=process(s,Fs,lm)

% Replace NaN measurements with average along the relevant dimension.
% (script adapted from MT via MVIEW)
s = fixNaN(s);

if size(s,2)>1
    % Find the interval I over which to compute U.
    winSize = 50; % msec
    win = ms2sampl(winSize,Fs);
    win = fix(win/2);
    i = [max(1,lm-win),min(size(s,1),lm+win)];
    % Project signal S onto one dimension.
    u = getPC(s(i(1):i(2),:));
    sHat = proj(s,u);
else
    sHat = s;
end

% Compute velocity using central differences.
v = computeVelocity(sHat,Fs);

% Filter velocity.
fLen=5;
fWin=ms2sampl(fLen,Fs);
fv = filter(ones(1,fWin)./fWin,1,v);

end