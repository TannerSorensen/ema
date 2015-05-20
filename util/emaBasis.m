function yHat = emaBasis(iDir,fl,lm,an)
% Input:
%   IDIR - string, input directory with EMA files.
%   FL - struct array, entries contain field NAME with file names.
%   LM - vector of double, landmarks from files in FL.
%   AN - string, articulator name.
% Output:
%   Y - smoothed functional data object.

% Add FDA scrpts to path.
% (written by James Ramsay)
addpath(fdaPath)
% ODIR is the original current directory.
oDir = cd;
% IDIR is the directory where the files of FL are saved.
cd(iDir)
for i = 1:length(fl)
    % Import data.
    fn = fl(i).name;
    [~,~,s,Fs] = emaImport(fn,an);
    
    % Project S onto principal component U over window of length WIN.
    win=ms2sampl(200,Fs);
    c=ms2sampl(lm(i),Fs);
    if dataGuard(s)
        sHat = pcaProj(s,c,Fs,win);
        % Row I of matrix Y is projection SHAT of S onto U over window WIN.
        win=ceil([-win win]/2)+c;
        if i==1
            % Initialize output.
            y=NaN(length(fl),win(2)-win(1)+1);
        end
        y(i,:)=sHat(win(1):win(2));
    end
end

y=y(~isnan(y(:,1)),:);

% Smooth.
t=0:Fs:size(y,2)*Fs-1;
norder=6;
nbasis=length(t)+norder-2;
tBasis = create_bspline_basis([t(1) t(end)],nbasis,norder,t);
pars=fdPar(tBasis, 4, 0.01);
yHat=smooth_basis(t,y',pars);

% Return to ODIR.
cd(oDir)

end