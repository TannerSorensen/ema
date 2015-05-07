function [y,u,lambda] = pcaProj(x,tpvGuess,srate,pcaWin)
% output: Y is 1D version of input X. U is principal component vector.

% Convert pcaWin to samples
pcaWin = ms2sampl(pcaWin,srate);
% Divide it by two.
pcaWin = fix(pcaWin/2);
% Find the interval I over which to compute U.
I = [tpvGuess-pcaWin,tpvGuess+pcaWin];

% Find covariance matrix SIGMA over I.
sigma = cov(x(I(1):I(2),:));
[V,D] = eig(sigma);
lambda = vecRev(diag(D));
u = V(:,end);
u = u.';
y = (u * x.').';

end