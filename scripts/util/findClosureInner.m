function [lle,lre,tClo,fClo,rle,rre] = findClosureInner(x, srate, fClo,vargin)

fClo = ms2sampl(fClo,srate);

x_y = x(:,2);

% filter signal with a rectangular moving average
fwin = vargin{2};
fx_y = filtfilt(ones(1,fwin)./fwin,1,FixNaN(x_y));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% peak x_y (vertical displacement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find maximum of filtered signal
[~,pks] = findpeaks(fx_y);
[~,fClo] = min(abs(pks-fClo));
fClo = pks(fClo);
% find maximum of unfiltered signal nearest that of the filtered signal
[~,pks] = findpeaks(x_y);
[~,tClo] = min(abs(pks-fClo));
% We now have an estimate of the time of closure in the original signal.
tClo = pks(tClo);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% left and right edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
le = zeros(2,1);
re = le;
tpvGuess = [-50,50]+sampl2ms(fClo,srate);
for i = 1:2
    [le(i),~,~,~,re(i),~,~,~,~,~,~] = findLandmarks(x, srate, tpvGuess(i), vargin);
end
lle = le(1);
lre = re(1);
rle = le(2);
rre = re(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% unit conversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tClo = sampl2ms(tClo,srate);
fClo = sampl2ms(fClo,srate);
lle = sampl2ms(lle,srate);
lre = sampl2ms(lre,srate);
rre = sampl2ms(rre,srate);
rle = sampl2ms(rle,srate);

end
