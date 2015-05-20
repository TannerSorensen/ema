function plotLandmarks(fn,lmStr,tongue,lips,jaw,lm,winSize)
% Input:
%   WIN - plotted window size in msec.
warning('off','MATLAB:chckxy:nan')

% Import the EMA file. 
[~,~,s,Fs,S,pal,pha] = emaImport(fn,{tongue{:},jaw{:},lips{:}});

% Get the X and Y coordinates around LM for all articulators.
win=lm+repmat(ms2sampl(winSize/2,Fs),1,2).*[-1 1];
win=win(1):win(2);
for j=1:length(tongue)
    i=max(1,win(1)):min(length(s.(tongue{j})),win(end));
    x(:,j)=s.(tongue{j})(i,1);
    y(:,j)=s.(tongue{j})(i,2);
end
J=length(tongue);
for j=1:length(lips)
    i=max(1,win(1)):min(length(s.(lips{j})),win(end));
    x(:,J+j)=s.(lips{j})(i,1);
    y(:,J+j)=s.(lips{j})(i,2);
end
J=J+length(lips);
for j=1:length(jaw)
    i=max(1,win(1)):min(length(s.(jaw{j})),win(end));
    x(:,J+j)=s.(jaw{j})(i,1);
    y(:,J+j)=s.(jaw{j})(i,2);
end

% Independent variable time (msec).
win=repmat(ms2sampl(winSize/2,Fs),1,2).*[-1 1];
t=sampl2ms(win(1):win(2),Fs);

% Compute the velocity (cm/sec).
u=(Fs/10)*central_diff(x,t);
v=(Fs/10)*central_diff(y,t);

% Draw palate trace and rear pharynx wall.
hold on
plot(pal(:,1),pal(:,2),'black','LineWidth',2)
plot(pha(:,1),pha(:,2),'black','LineWidth',2)

% Draw initial tongue contour.
sx=linspace(x(1,1),x(1,length(tongue)));
sy=spline(x(1,1:length(tongue)),y(1,1:length(tongue)),sx);
r=plot(sx,sy,'Color','black','LineWidth',2);

% Draw initial particle positions.
p=plot(x(1,:),y(1,:),'o','MarkerFaceColor','red','MarkerEdgeColor','red');

% Draw initial particle velocities.
q=quiver(x(1,:),y(1,:),u(1,:),v(1,:),'Color','black','LineWidth',2);

% Set axis.
xl=xlim;
yl=ylim;
axis manual
hold off

% Initial time stamp.
tStamp=text(xl(1),yl(2)+2,sprintf('t=%.1f msec',t(1)));

% Animate movement of particle along curve.
for k = 2:size(x,1)
    % Update tongue contour.
    sx=linspace(x(k,1),x(k,length(tongue)));
    sy=spline(x(k,1:length(tongue)),y(k,1:length(tongue)),sx);
    set(r,'XData',sx,'YData',sy);
    
    % Update particle positions.
    set(p,'XData',x(k,:),'YData',y(k,:));
    
    % Update particle velocities.
    set(q,'XData',x(k,:),'YData',y(k,:),'UData',u(k,:),'VData',v(k,:));
    
    % Update time stamp.
    set(tStamp,'String',sprintf('t=%.0f msec',t(k)));

    pause(0.05)
end

delete(q)
warning('on','MATLAB:chckxy:nan')

end