function [tvp,fileName,skip] = findVp(srchStr, articulator, vargin)
% FINDVP - find the time of peak velocity TVP for a set of movement traces
% Input: 
%  1. SRCHSTR a regex which identifies the files to be analyzed
%  2. ARTICULATOR a string which identifies the name of the channel to be
%  analyzed.
%  3. VARGIN a cell array with the following elements.
%   (1) THRESHOLD - velocity threshold for delimiting the interval. 
%         The value of THRESHOLD is the percent of peak velocity PV such 
%         that LE is the last sample below MINIMUM+THRESHOLD*(PV-MINIMUM),  
%         before TPV and RE is the first sample below this same threshold 
%         after TPV, where MINIMUM is a minimum velocity found to the left 
%         and right of TPV.
%         This argument is ignored when ~strcmp(method,'threshold').
%         The default value of THRESHOLD is 0.2.
%   (2) FWIN - parameter for window size in the rectangular moving average
%   filter. 
%         The default value of FWIN is SRATE/20.
%   (3) MPHSCALAR - a velocity threshold for identifying LE and RE.
%         The value of MPHSCALAR is a numer in the interval (0,1] such that 
%         the value of the filtered signal at the initial estimates of the 
%         indices of LE and RE is not greater than the quantity 
%         MPHSCALAR*PV.
%   (4) METHOD - method of finding LE and RE
%         If strcmp(method,'threshold'), then LE and RE are found using
%         VTHRESHEDGES. If strcmp(method,'tan'), then the LE and RE are
%         found using VTANEDGES. See the documentation of these functions
%         for details.
%   (5) PREPROC - preprocessing of signal
%         If strcmp(preproc,'none'), do nothing. If
%         strcmp(preproc,'pcaProj'), then project X down onto the principal
%         component of X over the interval
%         [TPVGUESS-PCAWIN,TPVGUESS+PCAWIN].
%   (6) PCAWIN - size of window in msec over which the principal component
%   of X is computed. Arument ignored if ~strcmp(PREPROC,'pcaProj').
% 
% Output:
%  1. TVP - time point in msec of peak velocity
%  2. FILENAME - string name of the analyzed .MAT file.
%  3. SKIP - boolean indicating whether or not to skip this file later on
%  in the analysis.
%  
%  TS, 25.03.2015
fileName = dir(srchStr); N=length(fileName); tvp = ones(N,1); skip = zeros(N,1);
for i=1:N
    fn=fileName(i).name;
    S = load(fn);
    fn = fn(1:end-4);
    S = S.(fn);
    srate = S(strmatch(articulator,{S.NAME})).SRATE;
    audioSrate = S(1).SRATE;
    % For XRMB, find a subinterval of the whole recording time interval
    % (for long recordings like the hunter passages). If no text file
    % intervals.txt exists, then assume the recording is short enough to be
    % analyzed without.
    if ~isempty(strfind(fn,'TP'))
        dat = importdata('intervals.txt','\t',0);
        interval = dat.data(cellfun(@(x)strcmp(x,[fn '_mat ']),dat.textdata(:,1)),1:2);
        interval = interval*1000 + [-400 400];
        interval = ms2sampl(interval,srate);
        x = S(strmatch(articulator,{S.NAME})).SIGNAL(interval(1):interval(2),:);
        interval = sampl2ms(interval,srate);
        x = double(FixNaN(x));
    else
        x = S(strmatch(articulator,{S.NAME})).SIGNAL;
    end
    
    [b,a]=butter(6,(10*2)/srate); % 20 Hz * (1/Fn), Fn=Nyquist
    [~,x_init]=filter(b,a,repmat(x(1,:),100,1));
    x=filter(b,a,x,x_init);
    
    t = sampl2ms(1:length(x),srate);
    % take derivative
    x_t=zeros(size(x,1),1);
    for j=1:size(x,2)
        x_t=x_t+central_diff(x(:,j),1).^2;
    end
    x_t = mmsec2cmsec(sqrt(x_t),srate);

    % Plot signal and resultant velocity.
    if ~isempty(strfind(fn,'TP'))
        plotGUI(S,t,x,x_t,articulator,srate,audioSrate,[],interval)
    else
        plotGUI(S,t,x,x_t,articulator,srate,audioSrate)
    end
    % User input of guess TPVGUESS of the time of peak velocity TPV.
    [tvpGuess,~] = myginput(1);
    iter = 1;
    while (~isempty(tvpGuess) || iter == 1) && ~skip(i)
        % Find TVP with the function FINDLANDMARKS
        [le,lev,tvp(i),pv,re,rev,~,~,vp,~,~] = findLandmarks(x, srate, tvpGuess, vargin);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% unit conversion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        le = sampl2ms(le,srate);
        tvp(i) = sampl2ms(tvp(i),srate);
        re = sampl2ms(re,srate);
        % User input. If correct, press ENTER or RETURN twice ...
        if ~isempty(strfind(fn,'TP'))
            plotGUI(S,t,x,x_t,articulator,srate,audioSrate,{le,lev,tvp(i),pv,re,rev,vp},interval)
        else
            plotGUI(S,t,x,x_t,articulator,srate,audioSrate,{le,lev,tvp(i),pv,re,rev,vp})
        end
        % ... else press 1 to retry (ENTER or RETURN to proceed to the skip
        % option) ...
        redo = input('redo? [1] ');
        if ~isempty(redo), [tvpGuess,~] = myginput(1); else tvpGuess = []; end
        % ... press 1 to skip this token.
        skipp = input('skip? [1] ');
        if isempty(skipp), skip(i) = 0; else skip(i) = 1; end
        iter = iter+1;
    end
    clf
end
end