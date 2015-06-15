function v = computeVelocity(s,Fs)

%t=sampl2ms(0:(size(s,1)-1),Fs);
t=0:(1/Fs):(size(s,1)-1)*(1/Fs);
v=zeros(size(s,1),1);
for i=1:size(s,2)
    v=v+central_diff(s(:,i),t).^2;
end
v=sqrt(v);

end