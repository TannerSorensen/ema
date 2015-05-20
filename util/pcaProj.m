function [y,u,lambda] = pcaProj(s,c,Fs,win)
% output: 
%   Y is 1D version of input signal S. 
%   U is principal component vector.
%   LAMBDA is the vector of eigenvalues.
% input: 
%   signal S
%   center C around which to do PCA
%   sampling rate FS of S
%   window WIN in samples

% Convert pcaWin to samples
win = ms2sampl(win,Fs);
% Divide it by two.
win = fix(win/2);
% Find the interval I over which to compute U.
i = [c-win,c+win];

% Find covariance matrix SIGMA over I.
sigma = cov(s(i(1):i(2),:));
[v,d] = eig(sigma);
lambda = vecRev(double(diag(d)));
u = v(:,end);
u = u.';
y = (u * s.').';

end