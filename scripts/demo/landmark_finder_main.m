% LANDMARK_FINDER
% created Nov 8, 2014
% 
% Run this code to follow along in the landmark finder chapter of the EMA
% guide.

% Make working directory the path to the directory 
%   sorensen_matlab_scripts
% on your own system. This is where this file is located.

fileName = 'bulha_01_0005.mat';
articulator = 'TTIPPOS';

S = load(['../data/' fileName]);
tokenName = fileName(1:end-4);
S = S.(tokenName);

x = S(strmatch(articulator,{S.NAME})).SIGNAL;

srate = S(strmatch(articulator,{S.NAME})).SRATE;
audioSrate = S(strmatch('audio',{S.NAME})).SRATE;

t = sampl2ms(1:length(x),srate);

x_t = srate .* sqrt(sum(derivative(x).^2,2)) ./ 10;

% Plot signal and resultant velocity.
plotGUI(S,t,x,x_t,articulator,srate,audioSrate)

% User input of guess TPVGUESS of the time of peak velocity TPV.
[tpvGuess,~] = ginput(1); iter = 1; skip = 0;
while (~isempty(tpvGuess) || iter == 1) && ~skip
    
    % Find landmarks.
    [le,lev,tpv,pv,re,rev,u,hook,vp,disp,lambda] = findLandmarks(x, srate, tpvGuess, {.1,10,.8,'threshold','pcaProj',150});
    
    % User input. If correct, press ENTER. If you want to redo, guess 
    % again.
    plotGUI(S,t,x,x_t,articulator,srate,audioSrate,{le,lev,tpv,pv,re,rev,u,vp})
    redo = input('redo? [1] ');
    if ~isempty(redo), [tpvGuess,~] = ginput(1); else tpvGuess = []; end
    
    iter = iter+1;
end
cla

dur = re - le;

x_le = x(ms2sampl(le,srate),1); x_re = x(ms2sampl(re,srate),1);
y_le = x(ms2sampl(le,srate),2); y_re = x(ms2sampl(re,srate),2);
amp = sqrt((x_le - x_re).^2 + (y_le - y_re).^2);

if ~isempty(u)
    proj_u_x = (u * x.').';
    proj_u_x_le = proj_u_x(ms2sampl(le,srate)); 
    proj_u_x_re = proj_u_x(ms2sampl(re,srate));
    proj_amp = abs(proj_u_x_le - proj_u_x_re);
else
    proj_amp = [];
end

%% Visualize the projection onto and the movement along the PC

x_original = x(ms2sampl(le,srate):ms2sampl(re,srate),:);

u_vector = [0 0 ;u];

subplot(1,2,1);
N = length(x_original);
colr = 'black';
hold on
plot([-100*u(1) 100*u(1)],[-100*u(2) 100*u(2)],'-black','LineWidth',2);
plotX = x_original(:,1)-mean(x_original(:,1));
plotY = x_original(:,2)-mean(x_original(:,2));
scatter(plotX,plotY,[],colr,'filled');
xlim([.9*min(plotX) 1.1*max(plotX)]);
ylim([.9*min(plotY) 1.1*max(plotY)]);
xlabel('centered horizontal coordinate (mm)'),
ylabel('centered vertical coordinate (mm)'),
hold off
subplot(1,2,2);
proj_x_original = proj_u_x(ms2sampl(le,srate):ms2sampl(re,srate));
plot(sampl2ms(1:length(proj_x_original),srate),...
    proj_x_original,'-black','LineWidth',2);
xlim(sampl2ms([0 length(proj_x_original)+1],srate));
ylim(sampl2ms([min(proj_x_original)-1 max(proj_x_original)+1],srate));
xlabel('time (msec)'),ylabel('projected position (mm)')