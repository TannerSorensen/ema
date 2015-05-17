function data = fixNaN(data, dim)
%FIXNAN  - replace any NaNs in data with mean along specified dimension
%
%	usage:  data = FixNan(data, dim)
%
% default DIM is 1

% 03/00 mkt

if nargin<1,
	eval('help FixNaN');
	return;
end;
if nargin < 2, dim = 1; end;

if isempty(data), return; end;

dims = size(data);
nDims = length(dims);

%	put specified dimension first

notDim = find([1:nDims] ~= dim);
data = permute(data, [dim notDim]);

%	specialized nanmean

nans = isnan(data);
i = find(nans);
data(i) = zeros(size(i));
if min(size(data)) == 1,
	count = length(data) - sum(nans);
else,
	count = size(data,1) - sum(nans);
end;
j = find(count==0);
count(j) = ones(size(j));
y = sum(data)./count;
y(j) = j + NaN;
if min(size(data)) == 1,
	y = repmat(y, size(data));
else,
	y = repmat(y, [size(data,1) ones(1,nDims)]);
end;
for n = i, data(n) = y(n); end;

data = permute(data, [2:dim 1 dim+1:nDims]);
