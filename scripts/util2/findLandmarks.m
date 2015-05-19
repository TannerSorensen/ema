function [fl,lm] = findLandmarks(iStr,iDir,lmStr,an)
% Input:
%   ISTR - string, regular expression with which to search IDIR
%   IDIR - string, directory path within which to search for EMA files
%   LMSTR - string, landmark to search for (e.g., 'pv')
%   AN - string, channel in EMA file for desired articulator
% Output:
%   FL - struct array, elements contain field NAME, which is EMA file name
%   LM - vector of double, landmarks in msec for all EMA files found 
%   (NaN if the trial is to be skipped)

% Initialize output LM.
fl=dir(fullfile(iDir,iStr));
lm=NaN(length(fl),1);
% For each input ...
for i=1:length(fl)
    fn = fullfile(iDir,fl(i).name);
    try
        [a,Fa,s,Fs] = emaImport(fn,an);
        % ... assign the desired landmark to output LM.
        lm(i)=plotGUI(a,Fa,s,Fs,lmStr);
    catch e
        lm(i) = NaN;
    end
end

end