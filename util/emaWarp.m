function [rsm,w] = emaWarp(sm,t,nobs)

norder=5;
nbasis=length(t)+norder-2;
wBasis = create_bspline_basis([t(1) t(end)],nbasis,norder);
wpars=fdPar(wBasis, 1, 1);
[rsm,w]=register_fd(mean(sm),sm,wpars);

end