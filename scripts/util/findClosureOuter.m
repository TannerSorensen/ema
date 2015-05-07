function [lle,lre,tClo,fClo,rle,rre,skip] = findClosureOuter(matFileInfo,articulator,vargin)

fileName = matFileInfo.name;
S = load(sprintf('%s/%s',cd,fileName)); % load from cd into workspace
S = S.(fileName(1:(end-4))); % field name lacks .mat-extension of FILENAME

% Find the articulator trajectory, sample rate, vector of msec time points,
% and resultant velocity of signal.
srate = S(strmatch(articulator,{S.NAME})).SRATE;
x = S(strmatch(articulator,{S.NAME})).SIGNAL;
[b,a]=butter(6,20/srate); % filter with 20 Hz low-pass butterworth filter.
x = filter(b,a,x);
audioSrate = S(1).SRATE;
t = sampl2ms(1:length(x),srate);
x_t = mmsampl2cmsecVP(x,srate);

% Plot signal and resultant velocity.
clf
plotGUI(S,t,x,x_t,articulator,srate,audioSrate)

% User input of guess CLOSUREGUESS of the time of peak velocity TPV.
[closureGuess,~] = myginput(1); iter = 1; skip = 0;
while (~isempty(closureGuess) || iter == 1) && ~skip
    
    % Find closure.
    [lle,lre,tClo,fClo,rle,rre] = findClosureInner(x, srate, closureGuess,vargin);
    
    % User input. If correct, press ENTER twice. If you want to redo, press
    % 1, then ENTER.
    clf
    plotGUI(S,t,x,x_t,articulator,srate,audioSrate,...
        {lle,x_t(ms2sampl(lle,srate)),...
        tClo,x_t(ms2sampl(tClo,srate)),...
        rre,x_t(ms2sampl(rre,srate)),...
        x_t(ms2sampl(lle,srate):ms2sampl(rre,srate))})
    redo = input('redo? [1] ');
    if ~isempty(redo)
        [closureGuess,~] = myginput(1); 
    else
        closureGuess = []; 
        % If you want to skip this token (i.e. not record the measurements
        % in the output .txt file), press 1, then ENTER.
        skip = input('skip? [1] ');
        if isempty(skip), skip = 0; else skip = 1; end
    end
    iter = iter+1;
end
end
