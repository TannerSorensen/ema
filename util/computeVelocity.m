function [v,cv] = computeVelocity(s,Fs)

t=0:(1/Fs):(size(s,1)-1)*(1/Fs);
v=zeros(size(s,1),1);
for i=1:size(s,2)
    v=v+central_diff(s(:,i),t).^2;
end
v=sqrt(v);

cv = central_diff(s,t);

end