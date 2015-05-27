function [sHat,dsHat,ddsHat,Fs,nanInd] = emaCell(iDir,fl,lm,an)
% Input:
%   IDIR - string, input directory with EMA files.
%   FL - struct array, entries contain field NAME with file names.
%   LM - vector of double, landmarks from files in FL.
%   AN - string, articulator name.
%   WINSIZE - integer, length of window in msec.
% Output:
%   SHAT - cell array of double arrays, displacement along PC of the AN
%   signal.
%   DSHAT - cell array of double arrays, derivative of SHAT.
%   DDSHAT - cell array of double arrays, derivative of DSHAT.
%   T - time vector in seconds.
%   Fs - sample frequency of articulograph.

% Add FDA scrpts to path.
% (written by James Ramsay)
addpath(fdaPath)

sHat = cell(length(fl),1); dsHat=sHat; ddsHat=sHat;
lm = lm(:,[1 end]);

for i = 1:length(fl)
    
    % Import data.
    fn = fullfile(iDir,fl{i});
    [~,~,s,Fs] = emaImport(fn,an);
    
    % Find time window.
    cushion=ms2sampl(50,Fs);
    win=lm(i,:)+[-cushion cushion];
    
    if any(~isnan(s(:))) && ~any(isnan(lm(i,:)))
        t = 1000*(0:(1/Fs):(win(2)-win(1))*(1/Fs)); % on msec scale
        pc = getPC(s(win(1):win(2),:));
        sHatWide = proj(s(win(1):win(2),:),pc);
        
        norder=8;
        nbasis=length(t)+norder-2;
        tBasis = create_bspline_basis([t(1) t(end)],nbasis,norder,t);
        pars=fdPar(tBasis, norder-2, 10);
        sSm=smooth_basis(t,sHatWide',pars);
        dsSm=deriv(sSm);
        ddsSm=deriv(dsSm);
        dsHatWide=eval_fd(dsSm,t);
        ddsHatWide=eval_fd(ddsSm,t);
        
        sHat{i}=sHatWide(cushion+1:end-cushion);
        dsHat{i}=dsHatWide(cushion+1:end-cushion);
        ddsHat{i}=ddsHatWide(cushion+1:end-cushion);
    else
        sHat{i}=NaN;
        dsHat{i}=NaN;
        ddsHat{i}=NaN;
    end
end

nanInd = cellfun(@(x) any(isnan(x)),sHat);
sHat=sHat(~nanInd);
dsHat=dsHat(~nanInd);
ddsHat=ddsHat(~nanInd);

end