function [ x_t ] = mmsampl2cmsecVP( x,srate )
%MMSAMPL2CMSECVP takes a signal measured in mm/sample and returns its
%resultant velocity in cm/sec.
x_t = sqrt(sum(mmsec2cmsec(central_diff(x,1),srate).^2,2));
end

