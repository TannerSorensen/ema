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

% Assemble file list.
fl = dir(iDir);
fl = regexpi({fl.name},iStr,'match');
fl = [fl{:}];

% Initialize output LM.
nLm=floor(length(lmStr)/2);
lm=NaN(length(fl),nLm);

% For each input ...
i=1;
while i <= length(fl)
    fn = fullfile(iDir,fl{i});
    try
        [a,Fa,s,Fs] = emaImport(fn,an);
        % ... assign the desired landmark to output LM.
        [lm(i,:),incr]=plotGUI(a,Fa,s,Fs,lmStr,fn);
        % Increment index I.
        i=i+incr;
    catch e
        lm(i,:) = NaN(1,nLm);
        i=i+1;
    end
end

end