function x = fixNaN(x)
D=length(size(x));
if ~(0<D<3)
    error('Function FIXNAN only supports inputs of dimension 1 or 2.');
elseif D==1
    for i=1:length(x)
        if isnan(x(i)), x(i)=0; end
    end
else
    for i=1:size(x,1)
        for j=1:size(x,2)
            if isnan(x(i,j)), x(i,j)=0; end
        end
    end
end
end