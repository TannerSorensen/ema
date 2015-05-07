function [kinOut, vpOut] = findVPOuter(srchStr, type, subj, fileInputDir, articulator, spect, vargin)
% ANALYZETYPE - a wrapper function for ANALYZEMAT. This function allows the
% user to analyze all tokens in a directory of a particular type. It
% results in output files with kinematic quantities, velocity profiles, and
% time-normalized velocity profiles.
% 
% Input: 
%   (1) DATAFILENAME - name of the .txt file (with extension) to which the
%   results should be written.
%   (2) SRCHSTR - a string for which tokens will be sought by pattern
%   matching with regular expressions. This determines the movement type
%   which will be analyzed.
%   (3) TYPE - a string which indicates the name of the movement type. This
%   is written in the .txt file to identify the analyzed tokens as being
%   instances of this movement type. This string need not occur in the file
%   names to be analyzed.
%   (4) SUBJ - a string which indicates the subject name. This is written
%   in the .txt file to identify the analyzed tokens as being produced by
%   this subject. This string need not occur in the file names to be
%   analyzed.
%   (5) FILEOUTPUTDIR - a string which indicates the directory to which the
%   three output files will be written.
%   (6) FILEINPUTDIR - a string which indicates the directory from which 
%   the input .mat files should be read in.
%   (7) ARTICULATOR - a string which is the name of the articulator whose
%   movement trace is to be analyzed.
%   (8) VARGIN - a cell array of optional arguments to FINDLANDMARKS. See
%   FINDLANDMARKS (>> help findLandmarks) for details.
% Output: 
%   (1) a .txt file written to a file with name DATAFILENAME in the
%   directory FILEOUTPUTDIR. It contains kinematic quantities.
%   (2) a .txt file written to a file with name [DATAFILENAME '_vp'] in the
%   directory FILEOUTPUTDIR. It contains velocity profiles and acceleration
%   profiles on the original time scale. The units are cm/sec and cm/sec^2,
%   respectively.
%   (3) a .txt file written to a file with name [DATAFILENAME '_nvp'] in
%   the directory FILEOUTPUTDIR. It contains time-normalized velocity
%   profiles and acceleration profiles. The units are cm/sec and cm/sec^2,
%   respectively.
% 
% See also FINDVPINNER, FINDLANDMARKS.
% 
% TS, June 2014
% Updated to include acceleration profiles and normalized trajectories
% (FIDZ), TS, July 2014.
% Updates to the in-line documentation, TS, Nov 2014.
kinOut = struct('subj',cell(1),'type',cell(1),'fileName',cell(1),...
            'le',[],'lev',[],'tpv',[],'pv',[],'re',[],'rev',[],...
            'u',[],'dur',[],'amp',[],'proj_amp',[],...
            'meanCurv',[],'arcLength',[],'sk',[],...
            'lambda',[]);
% Take the .mat files from this directory.
cd(fileInputDir);
% Output status to console.
fprintf(1,'%s, %s\n',subj,type);
tokenList = dir(srchStr);
for i = 1:length(tokenList)
    fileName = tokenList(i).name;
    % Call the wrapper function of FINDLANDMARKS on the jth token of the
    % movement type.
    [le,lev,tpv,pv,re,rev,u,dur,amp,proj_amp,meanCurv,arcLength,sk,ap,vp,disp,pos,lambda,skip] = findVPInner(fileName,articulator,spect,vargin);
    % If the user indicates SKIP, then do not write the output of
    % ANALYZEMAT to the file output. 
    if ~skip
        
        kinOut.subj{i} = subj;
        kinOut.type{i} = type;
        kinOut.fileName{i} = fileName;
        kinOut.le(i) = le;kinOut.lev(i) = lev;kinOut.tpv(i) = tpv;kinOut.pv(i) = pv; ...
        kinOut.re(i) = re;kinOut.rev(i) = rev;kinOut.dur(i) = dur; ...
        kinOut.amp(i) = amp;kinOut.meanCurv(i) = meanCurv; ...
        kinOut.arcLength(i) = arcLength;
        if ~isempty(u)
            kinOut.u(i,1:length(u)) = u;
            kinOut.proj_amp(i) = proj_amp;
            kinOut.lambda(i,1:length(lambda)) = lambda;
            kinOut.sk(i) = sk;
        end
        
        vpOut.subj{i} = subj; vpOut.type{i} = type; vpOut.fileName{i} = fileName;
        vpOut.ap{i} = ap'; vpOut.vp{i} = vp'; vpOut.pos{i} = pos';
        if ~isempty(u), vpOut.disp{i} = disp'; end
    end
end

end