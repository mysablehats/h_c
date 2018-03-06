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
        dbgmsg('Dynamic fields for setting parscN is not yet tested. Fix this if things go wrong. Layers might not do what you believe they should. ')
        for i = 1:allc.parsc.maxlayernums
            dynfield = ['parsc' num2str(i)];
            if isfield(allc, dynfield)
                if isfield(allc.(dynfield), 'knn')&&isfield( allc.(dynfield).knn, 'other')
                    dbgmsg(['Found custom knn definition for layer:' num2str(i)])
                    parsc(i).knn.other = allc.(dynfield).knn.other;
                end
                if isfield(allc.(dynfield), 'svm')&&isfield(allc.(dynfield).svm, 'kernel')
                    dbgmsg(['Found custom svm kernel definition for layer:' num2str(i)])
                    %parsc(2).knn.other = {'''Distance'',@dtw_wrapper'};
                    parsc(i).svm.kernel = allc.(dynfield).svm.kernel;
                end
            end
        end
end