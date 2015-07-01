function mc = maxCon(s,Fs,guess)
% Input:
%   S - matrix, signal with channels in columns and samples in rows.
%   FS - integer, sample rate
%   GUESS - integer, time in msec of maximum constriction.
% Output:
%   MC - integer, time of maximum constriction in msec
%   (NaN if trial is to be skipped)

guess=ms2sampl(guess,Fs);
s=fixNaN(s);

% Project S onto superior-inferior axis.
s=s(:,2);

% Filter SHAT.
[~,~,fs] = process(s,Fs,guess);

% Find the displacement peak nearest to GUESS in projected and filtered 
% signal FSHAT.
[~,i]=findpeaks(fs);
[~,ii] = min(abs(i-guess));
mc=i(ii);

end