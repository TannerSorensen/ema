function vpPlot(v,Fs,ind,ylimit)

nGroup = length(unique(ind));

for i=1:nGroup
    vLittle=v(ind==i);
    for j=1:length(vLittle)
        subplot(2,ceil(nGroup/2),i)
        t=0:(1/Fs):(length(vLittle{j})-1)*(1/Fs);
        plot(t,vLittle{j})
        hold on
    end
    ylim([-ylimit ylimit])
end

end