function [pc,lambda] = getPC(gamma)
% input: 
%   GAMMA, matrix representing curve in 2+ dimensions.
%     Dimensions in columns, samples in rows.
% output: 
%   U is principal component vector.
%   LAMBDA is the vector of eigenvalues.

sigma = cov(gamma);
[v,d] = eig(sigma);
pc = v(:,end);

% Linearly transform PC to quadrants I and II.
% (Assumes that last component of the vector is superior-inferior.)
if pc(end) < 0
    pc=-pc;
end

% LAMBDA has largest eigenvalue first.
lambda = vecRev(double(diag(d))); 

