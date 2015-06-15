function Fs = getFs(iDir,fl,an)

if iscell(fl)
    fn = fl{1};
else
    fn = fl;
end

S = load(fullfile(iDir,fn));
S = S.(fn(1:end-4));
Fs = S(strcmpi(an,{S.NAME})).SRATE;

end