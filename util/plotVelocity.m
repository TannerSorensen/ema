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
    lm=varargin{1};
    [~,fv]=process(s,Fs,lm);
    scatter(t(lm),fv(lm),40,[.8 .2 .2],'filled')
    if length(lm)==3
        plot(t(lm(1):lm(3)), fv(lm(1):lm(3)), ...
            'Color',[0.9 0.2 0.2], 'LineWidth', 2)
    end
    hold off
end

end