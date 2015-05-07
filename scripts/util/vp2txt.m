function vp2txt( vpOut, fileName )
%VP2TXT outputs velocity profile data (integer,real, and string-valued) to 
% a file with .txt-extension.


t = 1:length(kinOut.disp);
for i = t
    fprintf(fid,'%s\t%s\t%s\t%d\t%f\t%f\t%f\n',subj,type,fileName(1:end-4),i,ap(i),vp(i),disp(i));
end
end

