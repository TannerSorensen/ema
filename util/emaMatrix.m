function [x,y,u,v,t,Fs] = emaMatrix(iDir,fl,lm,an,winSize)
% Input:
%   IDIR - string, input directory with EMA files.
%   FL - struct array, entries contain field NAME with file names.
%   LM - vector of double, landmarks from files in FL.
%   AN - string, articulator name.
%   WINSIZE - integer, length of window in msec.
% Output:
%   X - matrix of double, length(fl) rows and ms2sampl(winSize,Fs) columns.
%       displacement along first dimension of the AN signal.
%   Y - matrix of double, length(fl) rows and ms2sampl(winSize,Fs) columns.
%       displacement along second dimension of the AN signal.
%   U - matrix of double, length(fl) rows and ms2sampl(winSize,Fs) columns.
%       derivative of X.
%   V - matrix of double, length(fl) rows and ms2sampl(winSize,Fs) columns.
%       derivative of Y.
%   T - time vector in seconds.
%   Fs - sample frequency of articulograph.

for i = 1:length(fl)
    
    % Import data.
    fn = fullfile(iDir,fl{i});
    [~,~,s,Fs] = emaImport(fn,an);
    
    % Find time window.
    if length(lm(i,:))==1
        win=ms2sampl(winSize,Fs);
        win=ceil([-win win]/2)+lm(i);
    else
        win=ms2sampl(winSize,Fs);
        win=ceil([-win win]/2)+floor(mean(lm(i,:)));
    end
    
    if any(~isnan(s(:))) && ~any(isnan(lm(i,:)))
        
        if i==1
            % Initialize output.
            x=NaN(length(fl),win(2)-win(1)+1);
            y=x; u=x; v=x;
        end
        
        t = 0:(1/Fs):(size(y,2)-1)*(1/Fs);
        x(i,:)=s(win(1):win(2),1);
        y(i,:)=s(win(1):win(2),2);
        u(i,:)=central_diff(s(win(1):win(2),1),t);
        v(i,:)=central_diff(s(win(1):win(2),2),t);
    else
        x(i,:)=NaN;
        y(i,:)=NaN;
        u(i,:)=NaN;
        v(i,:)=NaN;
    end
    
    nanInd = isnan(x(:,1));
    x=x(~nanInd,:);
    y=y(~nanInd,:);
    u=u(~nanInd,:);
    v=v(~nanInd,:);
    
end



end