function y = sampl2ms(x,srate)
% sample to milliseconds
y = fix(1000 .* x ./ srate);
end
