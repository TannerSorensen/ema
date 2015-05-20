function tpv = peakVelocity(s,Fs,guess)
% Input:
%   FN - string, file name
%   AN - string, articulator name
% Output:
%   PV - integer, time of peak velocity in msec
%   (NaN if trial is to be skipped)

guess=ms2sampl(guess,Fs);

% Compute filtered velocity.
[v,fv]=process(s,Fs,guess);

% Find the peak nearest to PV in filtered signal MAV.
[~,i]=findpeaks(fv);
[~,ii] = min(abs(i-guess));
ftpv=i(ii);

% Find the peak nearest to FTPV in signal V.
[~,j]=findpeaks(v);
[~,jj] = min(abs(j-ftpv));
tpv=j(jj);

end