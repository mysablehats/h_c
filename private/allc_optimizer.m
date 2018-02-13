function allc = allc_optimizer
a = allconfigs;
oplist = createoptimizerlist(a);
allc = oplist;

end
function oplist = createoptimizerlist(a)
b = fieldnames(a);
oplist = struct();
for i = 1:length(b)
    ot = [];
    while(isempty(ot)||~(ot==0||ot==1))
        a.(b{i})
    ot = input('optimizable');
    end
    oplist.(b{i}).optimizable = ot;
end
end