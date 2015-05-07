function [arcLength,meanCurv] = findarcLeucC(x,t)
% findarcLeucC - find arc length and euclidean curvature.

% First, take derivatives.
y = x(:,2);
x = x(:,1);
x_t = derivative(x);
x_tt = derivative(x_t);
y_t = derivative(y);
y_tt = derivative(y_t);

% ARC LENGTH PARAMETRIZATION
% The cumulative arc length is
s = cumtrapz( sqrt(x_t.^2 + y_t.^2 ) );

% We need to interpolate to find the time point corresponding to equally
% spaced points along the curve.
X = s.';
V = [ t.', x, y ];

s0 = s(1);
L = s(end);
N = length(s);
Xq = linspace(s0,L,N); 

% NOTE: s(end) == sum(derivative(Xq))
% The result of our interpolation is:
% arc length in constant increments (first column)
% corresponding timepoints (second column)
% x as function of arc length (third column)
% y as function of arc length (fourth column)
Vq = interp1(X,V,Xq); 
% NOTE: derivative(Vq,1) shows that we are moving in steps of constant length 
% along the arc (first column) and the time steps are no longer equal
% (second column).
% The vectors xs and ys give the cartesian coordinates of the curve as a
% function of arclength (increments of approx. .1
xs = Vq(:,2);
ys = Vq(:,3);

% EUCLIDEAN CURVATURE
% oriented euclidean curvature as function of t
for i = 1:length(t)
    % euclidean curvature k_e by formula
    k_et(i) = det([x_t(i), y_t(i); x_tt(i), y_tt(i)])/norm([x_t(i),y_t(i)])^3;
end

% oriented euclidean curvature as function of s
x_s = derivative(xs);
x_ss = derivative(x_s);
y_s = derivative(ys);
y_ss = derivative(y_s);
k_es = zeros(length(t),1);
for i = 1:length(t)
    % euclidean curvature k_e by formula
    k_es(i) = det([x_s(i), y_s(i); x_ss(i), y_ss(i)])/norm([x_s(i),y_s(i)])^3;
end

% mean curvature
meanCurv = mean(k_es);
% arc length
arcLength = s(end);
end
