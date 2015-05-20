function [v,fv]=process(s,Fs,pca)

% Replace NaN measurements with average along the relevant dimension.
% (script adapted from MT via MVIEW)
s = fixNaN(s);

% Project signal S onto one dimension.
s = pcaProj(s,pca,Fs,80);

% Compute velocity using central differences.
v = computeVelocity(s,Fs);

% Filter velocity.
fLen=40;
fWin=ms2sampl(fLen,Fs);
fv = filter(ones(1,fWin)./fWin,1,v);

end