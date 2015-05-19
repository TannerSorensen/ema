function [a,Fa,s,Fs] = emaImport(fn,an)
% Input:
%   FN - string, file name
%   AN - string, channel name (e.g., T3)
% Output:
%   A - vector, audio signal
%   FA - integer, audio sampling frequency
%   S - matrix, EMA displacement signal
%   FS - integer, EMA sampling frequency

try
    S=load(fn);
    i=strfind(fn,'\');
    i=[i(end)+1 length(fn)-4];
    S=S.(fn(i(1):i(2)));
    a=S(strmatch('AUDIO',{S.NAME})).SIGNAL;
    a=rescale(a);
    Fa=S(strmatch('AUDIO',{S.NAME})).SRATE;
    s=S(strmatch(an,{S.NAME})).SIGNAL;
    Fs=S(strmatch(an,{S.NAME})).SRATE;
catch e
    s=NaN; a=NaN; Fs=NaN; Fa=NaN;
end


end