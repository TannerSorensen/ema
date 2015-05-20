function plotSpectrogram(a,Fa)

try
    % Compute spectrogram.
    segmentlen = round(10*Fa/1000); % 10 msec window
    noverlap=round(.1*segmentlen);
    [~,f,t,p] = spectrogram(a,segmentlen,noverlap,[],Fa);
    cutoff=10e3; % 10kHz cut-off
    i = find(f<cutoff); 

    % Plot spectrogram.
    surf(t,f(i),10*log10(abs(p(i,:))),'EdgeColor','none');
    axis xy, axis tight, colormap(gray), view(0,90);
    set(gca,'XTickLabel',[],'XTick',[],'xlim',[0,cutoff])
    ylabel('Frequency (Hz)')
catch e
    % No Signal Processing Toolbox?
end
end