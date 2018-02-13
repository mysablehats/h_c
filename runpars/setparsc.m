function parsc = setparsc(argarg, parsc)
%% this functions sets the parameters for the classifiers
allc = allconfigs;
switch argarg
    case 'init'
        %%% for knn
        parsc.knn.k = allc.parsc.knn.k; % default value
        parsc.knn.other = allc.parsc.knn.other;
        %parsc.knn.other = {'''Distance'',''hamming'''}; %use a hamming distance because pose 1 and 13 differ as much as 1 and 2
        %parsc.knn.other = {'''Distance'',@dtw'};
        %%% for svm
        %parsc.svm.kernel = 'linear';
        parsc.svm.kernel = allc.parsc.svm.kernel;
        parsc.svm.other = allc.parsc.svm.other;
    case 'layerdefs'
        parsc = repmat(parsc,allc.parsc.maxlayernums,1);
        %%% insert custom definitions for each layer below here
        %with dynamicfields this will work.
        warning('Dynamic fields for setting parscN is not implemented. Fix this if things go wrong. Layers might not do what you believe they should. ')
        parsc(1).knn.other = allc.parsc1.knn.other;
        %parsc(2).knn.other = {'''Distance'',@dtw_wrapper'};
        parsc(2).svm.kernel = allc.parsc2.svm.kernel;
end