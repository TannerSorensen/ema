function S = cvt(fileName)
% CVT - convert the format of a .mat EMA file to the required format.
% Right now, this basically only works on MTnew-esque files.
% 
% Input:
%  1. FILENAME - string with the name of the file to be loaded. Include
%  path name if not in the current directory.
%  2. ARTICULATOR - cell array whose elements are the string names of the
%  articulator variables corresponding to ul, ll, jaw, tt, tb, td.
% 
% The string FILENAME has the substring _head_ at least. The contents of
% this file are as follows.
% -------------------------------------
% - *_head_* is the articulatory data -
% -------------------------------------
% 
% DATA is a TxDxN double array.
% -T is the number of sampled time points.
% -D is the dimension of each sampled point.
% >> disp(dimension.axis{2})
% posx    
% posy    
% posz    
% orix    
% oriy    
% oriz    
% status  
% compdist
% -N is the number of receiver coils.
% >> disp(dimension.axis{3})
% REFR  
% REFL  
% NOSE1 
% NOSE2 
% TM    
% TB    
% UI    
% TT    
% UL    
% JAW   
% LL    
% unused
% 
% There is an accompanying audio file for the file FILENAME with the 
% following properties.
% ----------------------------
% - *_aNIDAQ_* is audio data -
% ----------------------------
% DATA is a Tx1 double array.
% -T is the number of sampled time points.
% 
% Last updated: TS, Feb. 2015

R = load(fileName);
artOut={'ul','ll','jaw','tt','tb','td'};
N_art = length(artOut);
S = struct('ul',[],'ll',[],'jaw',[],'tt',[],'tb',[],'td',[]);
S = struct('NAME',[],'SIGNAL',[],'SRATE',[]);
Q=load(strrep(fileName,'_head_','_aNIDAQ_'));
S(1).NAME='AUDIO';S(1).SIGNAL=Q.data;S(1).SRATE=Q.samplerate;
for i=2:(N_art+1)
    S(i).NAME=artOut{i-1};
    S(i).SIGNAL=R.data(:,1:3,strmatch(upper(artOut{i-1}),...
        upper(cellstr(R.dimension.axis{3}))));
    S(i).SRATE=R.samplerate;
end

end
