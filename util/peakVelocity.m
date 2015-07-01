function tpv = peakVelocity(s,Fs,guess)
% Input:
%   FN - string, file name
%   AN - string, articulator name
% Output:
%   PV - integer, time of peak velocity in msec

guess=ms2sampl(guess,Fs);

% Compute velocity.
v=computeVelocity(s,Fs);

% Find the peak nearest to GUESS in signal V.
[~,j]=findpeaks(v);
[~,jj] = min(abs(j-guess));
tpv=j(jj);

% Project onto PC around TPV.
projV=process(s,Fs,tpv);

% Find the peak nearest to GUESS in signal PROJV.
[~,j]=findpeaks(projV);
[~,jj] = min(abs(j-tpv));
tpv=j(jj);

end