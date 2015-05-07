function [ S ] = findSkewness( t, dx, n )
%findSkewness - compute the skewness of a curve DX sampled at points T. N
% is the order of polynomial approximation.
% 
% Note that if the warning appears that a polynomial is ill-conditioned,
% you have set N too high. Decrese N to ameliorate the problem, but make
% sure that you do not compromise the measurement by making too coarse a
% polynomial approximation to the density.
% 
% MATLAB Toolbox dependencies: Symbolic Math Toolbox
% 
% TS, June 2014
% Updated with dependency information, TS, December 2014

dx = abs(dx);
Xq = linspace(t(1),t(end));
Vq = interp1(t,dx,Xq,'spline');
coeffs = polyfit(Xq,Vq,n);
pol = poly2sym(coeffs);

% pdf
c = int(pol,t(1),t(end));
pdf = pol/c;

% mean
xPdf = pdf*poly2sym([1 0]);
mu = int(xPdf,t(1),t(end));

% variance
var = int(pdf*(poly2sym([1 0]) - mu)^2,t(1),t(end));

% skewness
CMthree = int(pdf*(poly2sym([1 0])-mu)^3,t(1),t(end));
SDthree = (var^(1/2))^3;
S = double(CMthree/SDthree);
  
end

