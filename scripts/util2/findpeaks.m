function i=findpeaks(s)

if size(s,2)>size(s,1), s=s'; end

sBack=circshift(s,-1);
sFwd=circshift(s,1);

i = sBack < s & sFwd < s;
i([1 end])=0;

end