function lm = findLandmarks(iStr,iDir,lmStr,an)
% Input:
%   ISTR - string, regular expression with which to search IDIR
%   IDIR - string, directory path within which to search for EMA files
%   LMSTR - string, landmark to search for (e.g., 'pv')
%   AN - string, channel in EMA file for desired articulator
% Output:
%   LM - vector of double, landmarks in msec for all EMA files found 
%   (NaN if the trial is to be skipped)

% Save original directory.
oDir=cd;
% Navigate to input directory.
cd(iDir)
% Initialize output LM.
fl=dir(iStr);
lm=NaN(length(fl),1);
% For each input ...
for i=1:length(fl)
    % ... assign the desired landmark to output.
    switch lmStr
        case 'pv'
            lm(i)=peakVelocity(fl(i).name,an);
    end
end
% Return to ODIR.
cd(oDir)

end