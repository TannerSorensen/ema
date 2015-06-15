function [sHat,dsHat,ddsHat] = emaEval(sm,t,Fs)

dsm = deriv(sm,1);
ddsm = deriv(sm,2);

sMat = eval_fd(sm,t);
dsMat = eval_fd(dsm,t);
ddsMat = eval_fd(ddsm,t);

sHat = cell(size(sMat,2),1);
dsHat = cell(size(sMat,2),1);
ddsHat = cell(size(sMat,2),1);

for i=1:size(sMat,2)
    mid = sampl2ms(ceil(size(sMat,1)/2),Fs);
    [le,re]=edges(sMat(:,i),Fs,...
        peakVelocity(sMat(:,i),Fs,mid));
    sHat{i} = sMat(max(1,le):min(end,re),i);
    dsHat{i} = dsMat(max(1,le):min(end,re),i);
    ddsHat{i} = ddsMat(max(1,le):min(end,re),i);
end


end