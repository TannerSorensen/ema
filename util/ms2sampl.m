function y = ms2sampl(x,srate)
% milliseconds to sample
y = fix(srate .* x ./ 1000);
end