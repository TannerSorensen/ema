function gammaHat = proj(gamma,v)
% output: 
%   Y is 1D version of input curve GAMMA. 
%   U is principal component vector.
%   LAMBDA is the vector of eigenvalues.
% input: 
%   GAMMA, matrix representing curve in 2+ dimensions.
%     Dimensions in columns, samples in rows.
%   V, row vector onto which to project GAMMA.

% Center signal S.
cGamma=gamma-repmat(mean(gamma,1),size(gamma,1),1);

% SHAT is the projection of S onto U.
gammaHat = (v' * cGamma')';

end