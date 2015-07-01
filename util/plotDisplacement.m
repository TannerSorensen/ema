function plotDisplacement(s,Fs,varargin)

t=sampl2ms(0:(size(s,1)-1),Fs);
s = s-repmat(mean(fixNaN(s),1),size(s,1),1);

colr = [.8,.3,.3;.3,.8,.3;.3,.3,.8];
for i=1:size(s,2)
    plot(t,s(:,i),'Color',colr(i,:),'LineWidth',2), hold on
end
ylabel('1-red,2-green,3-blue (mm)')
set(gca,'XTickLabel',[],'XTick',[])
xlim([t(1),t(end)])
ylim(max(abs(s(:)))*[-1.1 1.1]);

if nargin>2
    try
        lm = varargin{1};
        [v,fv,fs,u]=process(s,Fs,lm);
        scatter(t(lm([1 end])),fs(lm([1 end])),[],'k','filled')
        if length(lm)==3
            plot(t(lm(1):lm(3)), fs(lm(1):lm(3)), 'k', 'LineWidth', 2)
        end
    catch e
        
    end
end
hold off

end