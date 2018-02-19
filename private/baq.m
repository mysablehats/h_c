function arq_connect = baq(allconn)
%%%% building arq_connect
arq_connect = struct;
%arq_connect(1:length(allconn)) = struct('name','','method','','sourcelayer','', 'layertype','','q',[1 0],'params',struct([]));
for i = 1:length(allconn)
    arq_connect(i).name = allconn{i}{1};
    arq_connect(i).method = allconn{i}{2};
    arq_connect(i).sourcelayer = allconn{i}{3};
    arq_connect(i).input_cond = allconn{i}{4};
    arq_connect(i).layertype = allconn{i}{5};
    arq_connect(i).q = allconn{i}{6};
    arq_connect(i).params = allconn{i}{7};
    %%% hack I need this info in params as well
    arq_connect(i).params.q = arq_connect(i).q;
    %% sets the right labelling function for layer:
    parsc = allconn{i}{9};
    arq_connect(i).inputtype = allconn{i}{10};
    
    
    
    
    if ~isempty(parsc)&&~isempty(fieldnames(parsc))
        %%% variables for the classifier distance function
        % make sure you have everything here that you might have referenced in
        % allconfigs!
        layertype = arq_connect(i).layertype;
        q = arq_connect(i).q;
        skelldef = arq_connect(i).params.skelldef;
        idx = flipindexes(skelldef,q,layertype);
        
        switch allconn{i}{8}
            case 'knn'
                if isempty(parsc.knn.other)
                    arq_connect(i).params.label.classlabelling = eval(['@(x,y)fitcknn(x,y,''NumNeighbors'', ' num2str(allconn{i}{11}) ')']);
                else
                    arq_connect(i).params.label.classlabelling = eval(['@(x,y)fitcknn(x,y,''NumNeighbors'', ' num2str(allconn{i}{11}) ',' parsc.knn.other{:} ')']);
                end
            case 'svm'
                
                if isempty(parsc.svm.other)
                    arq_connect(i).params.label.classlabelling = eval(['@(x,y)fitcecoc(x,y, ''Learners'', templateSVM(''KernelFunction'',' parsc.svm.kernel '))' ]);
                else
                    arq_connect(i).params.label.classlabelling = eval(['@(x,y)fitcecoc(x,y, ''Learners'', templateSVM(''KernelFunction'',' parsc.svm.kernel '),' parsc.svm.other{:} ')' ] );
                end
            otherwise
                warning('name of function not found. will assume it is a matlab function name or function handle')
                if strfind(allconn{i}{8},'@')
                    disp(['Using function handle' allconn{i}{8} ' for labelling'])
                    arq_connect(i).params.label.classlabelling = allconn{i}{8};
                else
                    arq_connect(i).params.label.classlabelling = eval(['@' allconn{i}{8}]);
                end
        end
    end
end