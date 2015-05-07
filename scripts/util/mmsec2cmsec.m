function [ y ] = mmsec2cmsec( x, srate )
%MMSEC2CMSEC convert units from mm/sec to cm/sec
y = srate .* x ./ 10;
end

