function vpPlot(v,Fs,ind)

nGroup = length(unique(ind));

for i=1:nGroup
    vLittle=v(ind==i);
    for j=1:length(vLittle)
        subplot(2,ceil(nGroup/2),i)
        t=0:(1/Fs):(length(vLittle{j})-1)*(1/Fs);
        plot(t,abs(vLittle{j}))
        hold on
    end
end

end