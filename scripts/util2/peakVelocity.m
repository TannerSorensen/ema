function pv = peakVelocity(s,Fs,guess)
% Input:
%   FN - string, file name
%   AN - string, articulator name
% Output:
%   PV - integer, time of peak velocity in msec
%   (NaN if trial is to be skipped)

pv=ms2sampl(guess,Fs);

% Compute velocity (with PCA, splines).
v=process(s,Fs,pv);

% Find the peak nearest to PV in filtered signal MAV.
i=findpeaks(v);
pv = min(abs(i-pv));

end