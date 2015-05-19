function v=process(s,Fs,pca)

% Replace NaN measurements with average along the relevant dimension.
% (script adapted from MT via MVIEW)
s = fixNaN(s);

% Project signal S onto one dimension.
s = pcaProj(s,pca,Fs,80);

% Compute velocity using central differences.
v = computeVelocity(s,Fs);

end