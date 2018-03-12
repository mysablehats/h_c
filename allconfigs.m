function allc = allconfigs(varargin)
if nargin>0
    switch varargin{1}
        case 'optimizer'
            allc = allc_optimizer();
        case 'alsw'
            allc = alsw(varargin{2:end});
        case 'reset'
            allc = allconfigs_core(true);
    end
else
    allc = allconfigs_core(false);
end
end
function allc = allconfigs_core(reset)
persistent allc_store
if reset
   
    allc = [];
    clear allc_store
    disp('configs_c cleared')
    return
end
if isempty(allc_store)
    
    %% runpars
    allc.runpar.savesimvar = false;
    
    %% simvar
    
    %%% sets the running parameters for the classifier.
    
    allc.simvar.init = {'PARA' 0};
    
    allc.simvar.NODES_VECT = [100];
    allc.simvar.MAX_EPOCHS_VECT = [5];
    allc.simvar.ARCH_VECT = [31];
    
    allc.simvar.MAX_NUM_TRIALS = 1;
    allc.simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this
    
    %% parsc - setparsc
    
    % Loaded in baq.m:
    % 
    % variables that can be specified in distance/kernel functions are:     
    %       layertype = arq_connect(i).layertype;
    %       q = arq_connect(i).q;
    %       skelldef = arq_connect(i).params.skelldef;
    %       idx = flipindexes(skelldef,q,layertype);
    
    %%%% init
    %%% for knn
    allc.parsc.knn.k = 1; % default value
    allc.parsc.knn.other = {};
    %   allc.parsc.knn.other = {'''OptimizeHyperparameters'',''auto'',''HyperparameterOptimizationOptions'',struct(''AcquisitionFunctionName'',''expected-improvement-plus'')'};
    %   allc.parsc.knn.other = {'''Distance'',''hamming'''}; %use a hamming distance because pose 1 and 13 differ as much as 1 and 2
    %   allc.parsc.knn.other = {'''Distance'',@dtw'};
    %allc.parsc.knn.other = {'''Distance'',@(X,Y)graph_dist_wrapper(skelldef,X,Y)'};
    %%% for svm
    %   allc.parsc.svm.kernel = 'linear';
    allc.parsc.svm.kernel = '''gaussian''';
    allc.parsc.svm.other = {};
    
    %%%% layerdefs
    %%%%%%%%%%%%%%% attention! this will overwrite your definitions before,
    %%%%%%%%%%%%%%% so we aware of it, or your code won't run the networks
    %%%%%%%%%%%%%%% you want it to run!
    % this is problematic, but I will fix it when the problem comes
    allc.parsc.maxlayernums = 10;
    %%% insert custom definitions for each layer below here
    %comment out things you don't want to do. 
    %allc.parsc1.knn.other = {};
    %allc.parsc1.knn.other = {'''Distance'',@(X,Y)flipper(idx,X,Y)'};
    %parsc2.knn.other = {'''Distance'',@dtw_wrapper'};
    %allc.parsc2.svm.kernel = '''gaussian''';
    
    %% parsk
    
    allc.params.normdim = false; %% if true normalize the distance by the number of dimensions
    allc.params.distancetype.source = 'gas'; % 'gas' or 'ext'
    allc.params.distancetype.metric = 'euclidean';%'3dsum'; %either '3dsum' or 'euclidean'
    allc.params.distancetype.noaffine = true; %if false will correct affine transformations on the distance function as well. Quite slow - if on ext.
    allc.params.distancetype.cum = false;
    allc.params.distance.simple = true; %if false will rotate stuff around to a better position. TO DO: all these distances have to be condensed into a single thing...
    allc.params.flippoints = false;
    
    allc.params.layertype = '';
    allc.params.MAX_EPOCHS = [];
    allc.params.removepoints = true;
    allc.params.oldremovepoints = false;
    allc.params.startdistributed = false;
    allc.params.RANDOMSTART = false; % if true it overrides the .startingpoint variable
    allc.params.RANDOMSET = false; %true; % if true, each sample (either alone or sliding window concatenated sample) will be presented to the gas at random
    allc.params.savegas.resume = false; % do not set to true. not working
    allc.params.savegas.save = false;
    %allc.params.savegas.path = simvar.env.wheretosavestuff;
    allc.params.savegas.parallelgases = true;
    allc.params.savegas.parallelgasescount = 0;
    allc.params.savegas.accurate_track_epochs = true;
    %allc.params.savegas.P = simvar.P;
    allc.params.startingpoint = [1 2];
    allc.params.amax = 50; %greatest allowed age
    allc.params.nodes = []; %maximum number of nodes/neurons in the gas
    allc.params.numlayers = []; %%% will depend on the architecture used in simvar.
    allc.params.en = 0.006; %epsilon subscript n
    allc.params.eb = 0.2; %epsilon subscript b
    allc.params.gamma = 4; % for the denoising function
    
    allc.params.PLOTIT = false;
    allc.params.plottingstep = 0; % zero will make it plot only every epoch
    allc.params.plotonlyafterallepochs = true;
    
    allc.params.alphaincrements.run = false;
    allc.params.alphaincrements.zero = 0;
    allc.params.alphaincrements.inc = 1;
    allc.params.alphaincrements.threshold = 0.9;
    allc.params.multigas = false; %%%% creates a different gas for each action sequence. at least it is faster.
    
    %Exclusive for gwr
    allc.params.STATIC = true;
    %allc.params.at = 0.999832929230424; %activity threshold
    allc.params.at = 0.95; %activity threshold
    allc.params.h0 = 1;
    allc.params.ab = 0.95;
    allc.params.an = 0.95;
    allc.params.tb = 3.33;
    allc.params.tn = 3.33;
    
    %Exclusive for gng
    allc.params.age_inc                  = 1;
    allc.params.lambda                   = 3;
    allc.params.alpha                    = .5;     % q and f units error reduction constant.
    allc.params.d                           = .995;   % Error reduction factor.
    
    %Exclusive for SOM
    allc.params.nodesx = 8;
    allc.params.nodesy = 8;
    
    %Labelling exclusive variables
    allc.params.label.tobelabeled = true; % not used right now, to substitute whatIlabel
    allc.params.label.prototypelabelling = @altlabeller; % @labeling is the old version
    allc.params.label.classlabelling = @fitcknn;
    
    %% parsk layerdefs
    
    allc.params.layerdefsnum = 10;
    
    %%% we need to enable the gas distance for first and
    %%% second layers only
    
    %         params(1).distancetype.source = 'gas'; % or 'ext'
    %         params(2).distancetype.source = 'gas'; % or 'ext'
    %         params(1).at = 0.0099983; %activity threshold
    %         params(2).at = 0.0099999; %activity threshold
    %         params(3).at = 0.0099995; %activity threshold
    %         params(4).at = 0.00999998; %activity threshold
    %         params(5).at = 0.0099999; %activity threshold
    
    
    allc_store = allc;
else
    allc = allc_store;
end

end

%% allconnset

function allconn_set = alsw(parsk,parsc, useroptions)
allconn_set = {...
    {... %%%% ARCHITECTURE 1
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',[3 2],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},{{},{}},  'all',[3 2],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 2
    {'gng1layer',   'gng',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gng2layer',   'gng',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gng3layer',   'gng',{'gng1layer'},{{},{}},              'pos',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gng4layer',   'gng',{'gng2layer'},{{},{}},              'vel',[3 2],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},{{},{}},  'all',[3 2],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 3
    {'gng1layer',   'gng',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gng2layer',   'gng',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gng3layer',   'gng',{'gng1layer'},{{},{}},              'pos',[3 0],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gng4layer',   'gng',{'gng2layer'},{{},{}},              'vel',[3 0],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gngSTSlayer', 'gng',{'gng4layer','gng3layer'},{{},{}},  'all',[3 0],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 4
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[3 0],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',[3 0],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},{{},{}},  'all',[3 0],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 5
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 2 3],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 2 3],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',[3 2],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},{{},{}},  'all',[3 2],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 6
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[3 4 2],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[3 4 2],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},{{},{}},  'all',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 7
    {'gwr1layer',   'gwr',{'all'},{{},{}},                    'all',[3 2], parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'gwr1layer'},{{},{}},              'all',[3 2], parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 8
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[9 0], parsk(1),'knn',parsc(1),'nodes',useroptions.k}... %% now there is a vector where q used to be, because we have the p overlap variable...
    }...
    {...%%%% ARCHITECTURE 9
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',3,parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',3,parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',3,parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',3,parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwr5layer',   'gwr',{'gwr3layer'},{{},{}},              'pos',3,parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    {'gwr6layer',   'gwr',{'gwr4layer'},{{},{}},              'vel',3,parsk(6),'knn',parsc(6),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr6layer','gwr5layer'},{{},{}},  'all',3,parsk(7),'knn',parsc(7),'nodes'}
    }...
    {... %%%% ARCHITECTURE 10
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},{{},{}},  'all',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 11
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[3 2],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[3 2],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[3 2],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',[3 2],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},{{},{}},  'all',[1 0],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 12
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[9 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 13
    {'gwr1layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'gwr1layer'},{{},{}},              'vel',[9 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 14
    {'gwr1layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 15
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwr3layer',   'gwr',{'gwr1layer'},{{},{}},              'pos',[2 1],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    {'gwr4layer',   'gwr',{'gwr2layer'},{{},{}},              'vel',[2 1],parsk(4),'knn',parsc(4),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr3layer','gwr4layer'},{{},{}},  'all',[4 3],parsk(5),'knn',parsc(5),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 16
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 17
    {'gwr1layer',   'gwr',{'all'},{{},{}},                    'all',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 18
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'gwr2layer',   'gwr',{'vel'},{{},{}},                    'vel',[1 0],parsk(2),'knn',parsc(2),'nodes',useroptions.k}...
    {'gwrSTSlayer', 'gwr',{'gwr1layer','gwr2layer'},{{},{}},  'all',[100 0],parsk(3),'knn',parsc(3),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 19
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'',useroptions.k}...
    {'knn2layer',   'knn',{'gwr1layer'},{{},{}},              'pos',[useroptions.w 0],parsk(2),'svm',parsc(2),'indexes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 20
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 11],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 12],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 13],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 14],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 15],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 16],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 17],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 18],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 19],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 21],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 21
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[useroptions.w ceil((useroptions.w)/2)],parsk(1),'knn',parsc(1),'nodes',useroptions.k+ 5}...
    }...
    {...%%%% ARCHITECTURE 22
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +0}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +1}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +2}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +3}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +4}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +5}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +6}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +7}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +8}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +9}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +10}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +11}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +12}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +13}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +14}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +15}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +16}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +17}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +18}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +19}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +20}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +21}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +22}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +23}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +24}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +25}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +26}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +27}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +28}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +29}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +30}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +31}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +32}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +33}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +34}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +35}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +36}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +37}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +38}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +39}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +40}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +41}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +42}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +43}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +44}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +45}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +46}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +47}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +48}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +49}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +50}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +51}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +52}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +53}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +54}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +55}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +56}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +57}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +58}...
    %     {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k +59}...
    }...
    {...%%%% ARCHITECTURE 23
    {'gwr1layer',   'knn',{'pos'},{{},{}},                    'pos',[useroptions.w 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 24
    {'gwr1layer',   'knn',{'pos'},{{},{}},                    'pos',[10 0],parsk(1),'svm',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 25
    {'knn1layer',   'knn',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 26
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'',useroptions.k}...
    {'knn2layer',   'knn',{'gwr1layer'},{{},{}},              'pos',[useroptions.w 0],parsk(2),'knn',parsc(2),'indexes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 27
    {'gwr1layer',   'knn',{'pos'},{{'ms'},{}},                'pos',[useroptions.w 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 28
    {'gwr1layer',   'knn',{'pos'},{{},{}},                    'pos',[useroptions.w 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {...%%%% ARCHITECTURE 29
    {'gwr1layer',   'knn',{'pos'},{{'ms'},{'ms'}},                    'pos',[useroptions.w 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 30
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn2layer',   'knn',{'gwr1layer'},{{'rd'},{}},              'pos',[useroptions.w 0],parsk(2),'knn',parsc(2),'indexes',useroptions.k}...
    }...
    {... %%%% ARCHITECTURE 31
    {'gwr1layer',   'gwr',{'pos'},{{},{}},                    'pos',[1 0],parsk(1),'knn',parsc(1),'nodes',useroptions.k}...
    {'knn2layer',   'knn',{'gwr1layer'},{{'rd'},{}},              'pos',[useroptions.w 0],parsk(2),'svm',parsc(2),'indexes',useroptions.k}...
    }...
    };

end