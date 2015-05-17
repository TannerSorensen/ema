function plotWaveform(a,Fa)

t = sampl2ms(0:(length(a)-1),Fa);
plot(t,a,'black')
set(gca,'XTickLabel',[],'XTick',[]),xlim([t(1),t(end)])

end