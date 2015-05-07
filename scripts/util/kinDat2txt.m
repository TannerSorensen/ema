function [ output_args ] = kinDat2txt( kinOut, fileName )
%KINDAT2TXT outputs kinematic data (integer, real, and string-valued) to a
%file with .txt extension.
% INPUT: 
% 1. 

fid = fopen([ fileOutputDir '/' dataFileName '.txt' ],'w');
fprintf(fid,'subj\tcvc\ttoken\tle\tlev\ttpv\tpv\tre\trev\tu1\tu2\tdur\tamp\tprojAmp\tmeanCurv\tarcLength\tskewness\teig1\teig2\n');

for i = 1:length(subj)
    fprintf(fid,'%s\t%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',...
        vpOut.subj{i},vpOut.type{i},vpOut.fileName{i}(1:end-4),...
        vpOut.le(i),vpOut.lev(i),vpOut.tpv(i),vpOut.pv(i),vpOut.re(i),...
        vpOut.rev(i),vpOut.u(i,1),vpOut.u(i,2),vp.dur(i),vpOut.amp(i),...
        vpOut.proj_amp(i),vpOut.meanCurv(i),vpOut.arcLength(i),...
        vpOut.sk(i),vpOut.lambda(i,1),vpOut.lambda(i,2));
end
fclose(fid);



end

