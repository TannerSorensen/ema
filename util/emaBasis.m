function [xHat,yHat,t] = emaBasis(iDir,fl,lm,an)
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
for i = 1:length(fl)
    % Import data.
    fn = fullfile(iDir,fl{i});
    [~,~,s,Fs] = emaImport(fn,an);
    
    % Project S onto principal component U over window of length WIN.
    win=ms2sampl(400,Fs);
    if any(~isnan(s(:))) && ~isnan(lm(i))
        % Row I of matrix Y is projection SHAT of S onto U over window WIN.
        win=ceil([-win win]/2)+lm(i);
        if i==1
            % Initialize output.
            x=NaN(length(fl),win(2)-win(1)+1);
            y=NaN(length(fl),win(2)-win(1)+1);
        end
        x(i,:)=s(win(1):win(2),1);
        y(i,:)=s(win(1):win(2),2);
    else
        x(i,:)=NaN;
        y(i,:)=NaN;
    end
end

x=x(~isnan(x(:,1)),:);
y=y(~isnan(y(:,1)),:);

% Smooth.
t=linspace(0,(size(y,2)-1)*(1/Fs),size(y,2));
norder=6;
nbasis=length(t)+norder-2;
tBasis = create_bspline_basis([t(1) t(end)],nbasis,norder,t);
pars=fdPar(tBasis, 4, 0.01);
yHat=smooth_basis(t,y',pars);
xHat=smooth_basis(t,x',pars);
end