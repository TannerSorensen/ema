function [a,Fa,s,Fs,S,pal,pha] = emaImport(fn,an)
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
    
    % Palate and pharynx if available.
    try
        pal=S.pal;
        pha=S.pha;
    catch e2
        pal=[];
        pha=[];
    end
    
    i=strfind(fn,'\');
    i=[i(end)+1 length(fn)-4];
    S=S.(fn(i(1):i(2)));
    
    % Audio normalized to interval [-1,+1].
    a=S(strncmpi('AUDIO',{S.NAME},5)).SIGNAL;
    a=rescale(a);
    Fa=S(strncmpi('AUDIO',{S.NAME},5)).SRATE;
    
    % receiver coil AN.
    if iscell(an)
        for i=1:length(an)
            d=size(S(strncmpi(an{i},{S.NAME},length(an{i}))).SIGNAL,2);
            s.(an{i})=double(S(strncmpi(an{i},{S.NAME},length(an{i}))).SIGNAL(:,1:min(3,d)));
            Fs=S(strncmpi(an{i},{S.NAME},length(an{i}))).SRATE;
        end
    else
        d=size(S(strncmpi(an,{S.NAME},length(an))).SIGNAL,2);
        s=double(S(strncmpi(an,{S.NAME},length(an))).SIGNAL(:,1:min(3,d)));
        Fs=S(strncmpi(an,{S.NAME},length(an))).SRATE;
    end
    
catch e1
    s=NaN; a=NaN; Fs=NaN; Fa=NaN;
end


end