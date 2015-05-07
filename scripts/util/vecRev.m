function [ v_r ] = vecRev( v )
%VECREV - reverse indices of vector V.
%   Input:
%   V - row or column vector of length N whose elements are 
%       [v(1) v(2) ... v(N)].
%   Output:
%   V_R - row or column vector of length N whose elements are 
%         [v(N) v(N-1) ... v(1)].
% 
% TS, December, 2014.

v_r = v(end:-1:1);


end

