function [le,lev,tpv,pv,re,rev,u,dur,amp,proj_amp,meanCurv,arcLength,sk,ap,vp,disp,pos,lambda,skip] = findVPInner(fileName,articulator,vargin)
%FINDVPINNER - a wrapper function for findLandmarks which incorporates a GUI
%for interactive user feedback during landmark selection.
% 
% See also FINDVPOUTER, FINDLANDMARKS.
% 
% TS, April 2015

% Read in the MAT file.
if isempty(strfind(fileName,'_head_'))
    S = load(fileName);
    tokenName = fileName(1:end-4);
    S = S.(tokenName);
else
    S = cvt(fileName);
end

% Create data structures.
matchd=strmatch(upper(articulator),upper({S.NAME}));
x = S(matchd).SIGNAL;
if size(x,2)>3, x=x(:,1:3); end
srate = S(matchd).SRATE;
t = sampl2ms(1:length(x),srate);
x_t=zeros(size(x,1),1);
for i=1:size(x,2)
    x_t=x_t+central_diff(x(:,i),1).^2;
end
x_t = mmsec2cmsec(sqrt(x_t),srate);
audioSrate = S(1).SRATE;

% Plot spectrogram, position signals, and resultant velocity.
plotGUI(S,t,x,x_t,articulator,srate,audioSrate)

% User input of guess TPVGUESS of the time of peak velocity TPV.
[tpvGuess,~] = myginput(1); iter = 1; skip = 0;
while (~isempty(tpvGuess) || iter == 1) && ~skip
    
    % Find landmarks with the function FINDLANDMARKS
    [le,lev,tpv,pv,re,rev,u,ap,vp,disp,lambda] = findLandmarks(x, srate, tpvGuess, vargin);
    
    % User input. If correct, press ENTER twice ...
    plotGUI(S,t,x,x_t,articulator,srate,audioSrate,...
        {sampl2ms(le,srate),lev,sampl2ms(tpv,srate),pv,sampl2ms(re,srate),rev,vp})
    % ... else press 1 to retry (ENTER to proceed to the skip option) ...
    redo = input('redo? [1] ');
    if ~isempty(redo), [tpvGuess,~] = myginput(1); else tpvGuess = []; end
    % ... press 1 to skip this token.
    skip = input('skip? [1] ');
    if isempty(skip), skip = 0; else skip = 1; end
    
    iter = iter+1;
end
clf

% Derive the quantities dur, amp, proj_amp, meanCurv, arcLength, and sk.
[arcLength,meanCurv] = findarcLeucC(x,t);
dur = sampl2ms(re-le,srate);
x_le = x(le,1); x_re = x(re,1);
y_le = x(le,2); y_re = x(re,2);
amp = sqrt((x_le - x_re).^2 + (y_le - y_re).^2);
pos = x(le:re,:);
if ~isempty(u)
    proj_u_x = (u * x.').';
    proj_u_x_le = proj_u_x(le); 
    proj_u_x_re = proj_u_x(re);
    proj_amp = abs(proj_u_x_le - proj_u_x_re);
    dxx = central_diff(proj_u_x(le:re),1);
    tt = linspace(le/1000,re/1000,length(dxx)).';
    sk = findSkewness(tt,dxx,4);
else
    proj_amp = [];
    sk = [];
end

% unit conversion
le = sampl2ms(le,srate);
tpv = sampl2ms(tpv,srate);
re = sampl2ms(re,srate);

end