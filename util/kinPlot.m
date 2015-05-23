function kinPlot(sHat,dsHat,ddsHat,Fs,ind)

nGroup = length(unique(ind));

for i=1:nGroup
    ddsLittle=ddsHat(ind==i);
    dsLittle=dsHat(ind==i);
    sLittle=sHat(ind==i);
    MT = NaN(length(dsLittle),1);
    PV = MT; PA = MT; A = MT; 
    for j=1:length(dsLittle)
        sTiny=sLittle{j};
        MT(j)=(length(sTiny)-1)*(1/Fs);
        PV(j)=1e3*max(abs(dsLittle{j}))./10; % cm/sec
        PA(j)=1e3^2*max(abs(ddsLittle{j}))./10;
        A(j)=abs(sTiny(end)-sTiny(1));
    end
    figure(1)
    subplot(2,ceil(nGroup/2),i)
    colr=repmat((max(A)-A)/max(A),1,3);
    scatter(MT,PV./A,'filled')
    xlim([0 0.3]), ylim([0 2])
    figure(2)
    subplot(2,ceil(nGroup/2),i)
    scatter(A,PV),lsline
    xlim([0 22]), ylim([0 30]), axis square, hold off
    figure(3)
    subplot(2,ceil(nGroup/2),i)
    scatter(A,PA),lsline
    xlim([0 22]), ylim([0 700]), axis square
end

end