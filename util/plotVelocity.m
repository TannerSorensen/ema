function plotVelocity(s,Fs,varargin)

% Compute velocity.
v = computeVelocity(s,Fs);
t = sampl2ms(0:(size(s,1)-1),Fs);

% Plot velocity.
plot(t,v,'Color','black','LineWidth',2)
ylabel('cm/sec'),xlabel('time (msec)')
xlim([t(1),t(end)])
ylim([0,1.1*max(v)])

% Plot peak velocity (if present).
if ~isempty(varargin)
    hold on
    pv=varargin{1};
    scatter(sampl2ms(pv,Fs),v(pv),40,[.8 .2 .2],'filled')
    hold off
end

end