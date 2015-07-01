function plotVelocity(s,Fs,varargin)

% Compute velocity.
v = computeVelocity(s,Fs);
t = sampl2ms(0:(size(s,1)-1),Fs);

% Plot velocity.
if ~isempty(varargin)
    lm=varargin{1};
    [~,fv]=process(s,Fs,lm);
    plot(t,fv,'k','LineWidth',2), hold on
    scatter(t(lm),fv(lm),40,[.8 .2 .2],'filled'), hold off
else
    plot(t,v,'Color','black','LineWidth',2)
end

ylabel('cm/sec'),xlabel('time (msec)')
xlim([t(1),t(end)])
ylim([0,1.1*max(v)])

end