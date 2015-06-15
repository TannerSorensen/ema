function [smHat,t] = emaBasis(iDir,fl,lm,an)
% Input:
%   IDIR - string, input directory with EMA files.
%   FL - struct array, entries contain field NAME with file names.
%   LM - vector of double, landmarks from files in FL.
%   AN - string, articulator name.
% Output:
%   SMHAT - smoothed functional data object.

% Add FDA scrpts to path.
% (written by James Ramsay)
addpath(fdaPath)

if size(lm,2)==3
    lm=lm(:,2);
elseif size(lm,2)==2
    lm=floor(mean(lm,2));
end

fl = fl(~isnan(lm));
lm = lm(~isnan(lm));

for i = 1:length(fl)
        
        % Import data.
        fn = fullfile(iDir,fl{i});
        [~,~,s,Fs] = emaImport(fn,an);
        
        % Find larger delimiting time window.
        winDSize=ms2sampl(400,Fs);
        winD=ceil([-winDSize winDSize]/2)+lm(i);
        
        % Find smaller PCA time window.
        winPCASize=ms2sampl(50,Fs);
        winPCA=ceil([-winPCASize winPCASize]/2)+lm(i);
        
        if i==1
            % Initialize output.
            sHat=NaN(length(fl),winD(2)-winD(1)+1);
        end
        
        
        % Find projection SHATWIDE of S onto PC over window of length
        % WINSIZE.
        pc = getPC(s(winPCA(1):winPCA(2),:));
        sHat(i,:) = proj(s(winD(1):winD(2),:),pc);
end

% Smooth SHAT.
t=linspace(0,(size(sHat,2)-1)*(1/Fs),size(sHat,2));
norder=8;
nbasis=length(t)+norder-2;
tBasis = create_bspline_basis([t(1) t(end)],nbasis,norder,t);
pars=fdPar(tBasis, norder-2, 1e2);
smHat=smooth_basis(t,sHat',pars);

end