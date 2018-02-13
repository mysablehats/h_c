function params = setparsk(skelldef, argarg, params)
allc = allconfigs;
%% This function sets the parameters for the compressors
switch argarg
    case 'init'       
        params.skelldef = skelldef;
        params.normdim = allc.params.normdim; 
        params.distancetype.source = allc.params.distancetype.source;
        params.distancetype.metric = allc.params.distancetype.metric;
        params.distancetype.noaffine = allc.params.distancetype.noaffine; 
        params.distancetype.cum = allc.params.distancetype.cum;
        params.distance.simple = allc.params.distance.simple; 
        params.flippoints = allc.params.flippoints;
        
        params.layertype = allc.params.layertype;
        params.MAX_EPOCHS = allc.params.MAX_EPOCHS;
        params.removepoints = allc.params.removepoints;
        params.oldremovepoints = allc.params.oldremovepoints;
        params.startdistributed = allc.params.startdistributed;
        params.RANDOMSTART = allc.params.RANDOMSTART;
        params.RANDOMSET = allc.params.RANDOMSET; 
        params.savegas.resume = allc.params.savegas.resume; 
        params.savegas.save = allc.params.savegas.save;
        %params.savegas.path = allc.params.savegas.path;
        params.savegas.parallelgases = allc.params.savegas.parallelgases;
        params.savegas.parallelgasescount = allc.params.savegas.parallelgasescount;
        params.savegas.accurate_track_epochs = allc.params.savegas.accurate_track_epochs;
        %params.savegas.P = allc.params.savegas.P;
        params.startingpoint = allc.params.startingpoint;
        params.amax = allc.params.amax; 
        params.nodes = allc.params.nodes; 
        params.numlayers = allc.params.numlayers; 
        params.en = allc.params.en; 
        params.eb = allc.params.eb; 
        params.gamma = allc.params.gamma; 
        
        params.PLOTIT = allc.params.PLOTIT;
        params.plottingstep = allc.params.plottingstep;
        params.plotonlyafterallepochs = allc.params.plotonlyafterallepochs;

        params.alphaincrements.run = allc.params.alphaincrements.run;
        params.alphaincrements.zero = allc.params.alphaincrements.zero;
        params.alphaincrements.inc = allc.params.alphaincrements.inc;
        params.alphaincrements.threshold = allc.params.alphaincrements.threshold;
        params.multigas = allc.params.multigas; 
        
        %Exclusive for gwr
        params.STATIC = allc.params.STATIC;
        params.at = allc.params.at; 
        params.h0 = allc.params.h0;
        params.ab = allc.params.ab;
        params.an = allc.params.an;
        params.tb = allc.params.tb;
        params.tn = allc.params.tn;
        
        %Exclusive for gng
        params.age_inc                  = allc.params.age_inc ;
        params.lambda                   = allc.params.lambda;
        params.alpha                    = allc.params.alpha;    
        params.d                        = allc.params.d;   
        
        %Exclusive for SOM
        params.nodesx = allc.params.nodesx;
        params.nodesy = allc.params.nodesy;
        
        %Labelling exclusive variables
        params.label.tobelabeled = allc.params.label.tobelabeled; 
        params.label.prototypelabelling = allc.params.label.prototypelabelling; 
        params.label.classlabelling = allc.params.label.classlabelling;
        
    case 'layerdefs'
        %% Classifier structure definitions
        
        %paramsP = repmat(params,simvar.numlayers,1);
        
        params = repmat(params,allc.params.layerdefsnum,1);
        
        warning('no consistent parameter abstraction implemented')
        %%% we need to enable the gas distance for first and
        %%% second layers only
        
%         params(1).distancetype.source = 'gas'; % or 'ext'
%         params(2).distancetype.source = 'gas'; % or 'ext'
%         params(1).at = 0.0099983; %activity threshold
%         params(2).at = 0.0099999; %activity threshold
%         params(3).at = 0.0099995; %activity threshold
%         params(4).at = 0.00999998; %activity threshold
%         params(5).at = 0.0099999; %activity threshold
         
        
end
end