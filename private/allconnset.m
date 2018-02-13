function allconn = allconnset(n, parskI,parsc, useroptions)
if isempty(parskI)||isempty(parsc)
    parsk = repmat(struct,10);
    parsc = repmat(struct,10);
elseif length(parskI)==1
    warning('**Parsk** is only a 1x1 structure. Was layerdefs not called? This should not happen!')
    parsk = repmat(parskI(1),10);
elseif length(parsc)==1
    warning('**Parsc** is only a 1x1 structure. Was layerdefs not called? This should not happen!')
    parsk = repmat(parsc(1),10);
end
for i=1:length(parskI)
    parsk(i) = parskI(i);
end
%%% not needed for parsc because i didnt decide to call it something
%%% different. also, this structure is needlessly complated. it should be
%%% simplified if this starts to give strange results.
% for i=1:length(parsc)
%     parsk(i) = parskI(i);
% end
allconn_set = allconfigs('alsw', parsk,parsc, useroptions);
allconn = allconn_set{n};
end
