function lm = plotGUI(a,Fa,s,Fs,lmStr)
% Input:
%   A - vector of double, audio signal
%   FA - integer, audio signal sampling frequency
%   S - vector of double, EMA signal
%   FS - integer, EMA sampling frequency
%   LMSTR - string, landmark name (e.g., 'pv')
% Output:
%   LM - integer, landmark time point in samples.
%
% GUI instructions for users
% 
%   select (hotkey s) - toggle select mode. when 
%     in select mode, click axes to select a 
%     landmark time point.
%   confirm (hotkey d) - confirm selection 
%     (selection is displayed as a red dot)
%     and advance to next token.
%   slider bar - move forward or backward in 
%     time (x-axis)
%   number field - change size of visible time 
%     window (msec)

    %---------------------
    % Create axes and GUI.
    %---------------------
    p = figInit(a,Fa,s,Fs);
    axes(p.h1), plotSpectrogram(a,Fa)
    axes(p.h2), plotWaveform(a,Fa)
    axes(p.h3), plotDisplacement(s,Fs,'center')
    axes(p.h4), plotVelocity(s,Fs)
    
    %--------------------
    % Interact with user.
    %--------------------
    while ~exist('done','var') || ~done
        
        % What should happen next?
        done=get(p.confirmToggle,'Value');
        select=get(p.selectToggle,'Value');
        
        if ~done && select
            % We are not done and we want 
            % to guess landmark time.
            
            % Guess the time of landmark LM.
            [guess,~] = myginput(1);
            set(p.selectToggle,'Value',0);
            
            % Home in on landmark time.
            switch lmStr
                case 'pv'
                    lm=peakVelocity(s,Fs,guess);
                case 'le'
                    [lm,~]=edges(s,Fs,...
                        peakVelocity(s,Fs,guess));
                case 're'
                    [~,lm]=edges(s,Fs,...
                        peakVelocity(s,Fs,guess));
                case 'lere'
                    lm=NaN(1,2);
                    [lm(1),lm(2)]=edges(s,Fs,...
                        peakVelocity(s,Fs,guess));
                otherwise
                    lm=NaN;
            end
            
            % Display landmark in axes H4.
            axes(p.h4), plotVelocity(s,Fs,lm)
            
        else
            % We are just not yet done, but 
            % we would like to do something 
            % else (e.g., zooming) before 
            % finding LM.
            
            pause(0.5)
        end
    end
    
    cleanUp(p.f);
end
