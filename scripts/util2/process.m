function v=process(s,Fs,spline,pca)

% Replace NaN measurements with average along the relevant dimension.
% (script from MT via MVIEW)
s = fixNaN(s);

if pca~=0
    % Project signal S onto one dimension.
    s = pcaProj(s,pca,Fs,80);
end

if spline
    addpath(bsplinePath)
    
    % Create and differentiate a bspline object for signal S.
    t=0:(size(s,1)-1);
    s=fixNaN(s);
    s=Bspline(s,4);
    v=diff(s);
    
    % Evaluate the derivative to get velocity V of signal S.
    v=v(t);
else
    % Compute velocity using central differences.
    v = computeVelocity(s,Fs);
end

end