function [a,Fa,s,Fs] = emaImport(fn,an)
% Input:
%   FN - string, file name
%   AN - string, channel name (e.g., T3)
% Output:
%   A - vector, audio signal
%   FA - integer, audio sampling frequency
%   S - matrix, EMA displacement signal
%   FS - integer, EMA sampling frequency

S=load(fn);
S=S.(fn(1:(end-4)));
a=S(strmatch('AUDIO',{S.NAME})).SIGNAL;
Fa=S(strmatch('AUDIO',{S.NAME})).SRATE;
s=S(strmatch(an,{S.NAME})).SIGNAL;
Fs=S(strmatch(an,{S.NAME})).SRATE;

end