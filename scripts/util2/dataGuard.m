function b = dataGuard(s)
% Input:
%   S - matrix of double, a signal
% Output:
%   B - boolean, 1 if s has non-NaN entries, else 0

if any(~isnan(s))
    b=1; 
else
    b=0;
end

end