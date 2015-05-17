function pv = peakVelocity(fn,an)
% Input:
%   FN - string, file name
%   AN - string, articulator name
% Output:
%   PV - integer, time of peak velocity in msec
%   (NaN if trial is to be skipped)

[a,Fa,s,Fs]=emaImport(fn,an);

while ~exist('b','var') || b==1
    % User input peak velocity PV.
    plotGUI(a,Fa,s,Fs,[]);
    [pv,~] = myginput(1);
    pv=ms2sampl(pv,Fs);
    clf
    
    % Compute velocity (with PCA, splines).
    v=process(s,Fs,1,pv);
    
    % Apply moving average filter to V.
    maWin=ms2sampl(150,Fs);
    mav=filter(ones(1,maWin)/maWin, 1, v);
    
    % Find the peak nearest to PV in filtered signal MAV.
    i=findpeaks(mav);
    i = min(abs(i-pv));
    
    % Display peak velocity at index I.
    plotGUI(a,Fa,s,Fs,i);
    b=input('0 + RETURN to advance.\n1 + RETURN to redo. \n2 + RETURN to skip.');
    if b==2, pv=NaN; end
    clf
end

pv = sampl2ms(pv,Fs);

end