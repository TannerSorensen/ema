function [p,i]=findpeaks(s,numPks,troughs)
% FINDPEAKS 
%   Input:
%     (1) S - one-dimensional signal
%     (2) NUMPKS - integer number of peaks desired (optional)
%     (3) FLIP - boolean, whether to flip signal sign (optional)

if size(s,2)>size(s,1), s=s'; end
if nargin>2, if troughs, s=-1*s; end, end

sBack=circshift(s,-1);
sFwd=circshift(s,1);

i = sBack < s & sFwd < s;
ii=1:length(s);
i=ii(i);
p=s(i);

if nargin>1
    i=i(1:numPks);
    p=p(1:numPks);
end
if nargin>2, if troughs, p=-1*p; end, end

end