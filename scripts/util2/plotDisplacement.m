function plotDisplacement(s,Fs,varargin)

if nargin>2
    center = varargin{1};
    if strcmp(center,'center')
        s = s-repmat(mean(fixNaN(s),1),size(s,1),1);
    end
end

t=sampl2ms(0:(size(s,1)-1),Fs);

colr = [.8,.3,.3;.3,.8,.3;.3,.3,.8];
for i=1:size(s,2)
    plot(t,s(:,i),'Color',colr(i,:),'LineWidth',2)
    hold on
end
hold off
ylabel('1-red,2-green,3-blue (mm)')
set(gca,'XTickLabel',[],'XTick',[])
xlim([t(1),t(end)])
ylim(max(abs(s(:)))*[-1.1 1.1]);

end