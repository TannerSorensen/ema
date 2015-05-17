function plotGUI(a,Fa,s,Fs,varargin)
% Input:
%   A - vector of double, audio signal
%   FA - integer, audio signal sampling frequency
%   S - vector of double, EMA signal
%   FS - integer, EMA sampling frequency
%   VARARGIN - estimated landmark in samples

% Dimensions of four panels.
bottom=linspace(0.7,0.1,4);
height=[.2 .3]-.01;
left=0.15;
width=.8;

figure(1);
% Panel 1
axes('Position',[left bottom(1) width height(2)]);
plotSpectrogram(a,Fa)
% Panel 2
axes('Position',[left bottom(2) width height(1)]);
plotWaveform(a,Fa)
% Panel 3
h3=axes('Position',[left bottom(3) width height(1)]);
plotDisplacement(s,Fs)
% Panel 4
h4=axes('Position',[left bottom(4) width height(1)]);
if isempty(varargin{1})
    plotVelocity(s,Fs)
else
    plotVelocity(s,Fs,varargin{1})
end
linkaxes([h3 h4],'x')

end