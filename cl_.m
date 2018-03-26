function [outcomes, cacc, time] = cl_(varargin)
passwd = evalin('base','passwd');
try
    myticvar = tic;
    
    global VERBOSE LOGIT TEST
    TEST = 0;
    VERBOSE = 0;
    
    addpath('runpars')%,'poscond','measures','debug','utils');
    currpwd = pwd;
    cd ..
    addpath('utils_matlab','dsl')
    cd(currpwd)
    
    allconfigs('reset');
    
    runpars = setrunparsc;
    savesimvar = runpars.savesimvar;
    
    useroptions = struct();
    
    [datavar_,runparsd] = dslw;
    
    precon = runparsd.precon;
    scene = runparsd.scene;
    maxindexofscenes = length(runparsd.scene);
    
    %%% this is a switch
    switch nargin
        case 4
            useroptions.k = varargin{1};
            useroptions.w = varargin{2};
            useroptions.n = varargin{3};
            useroptions.cw = varargin{4};
        case 3
            useroptions.k = varargin{1};
            useroptions.w = varargin{2};
            useroptions.n = varargin{3};
            useroptions.cw = 0;
        case 2
            useroptions.k = varargin{1};
            useroptions.w = varargin{2};
            useroptions.cw = 0;
        case 1
            useroptions.k = varargin{1};
            useroptions.w = 1;
            warning('Size of window not defined. Using 1. ')
            useroptions.cw = 0;
        case 0
            useroptions.k = 1;
            warning('Number of neigbours not defined. Using 1. ')
            useroptions.w = 1;
            warning('Size of window not defined. Using 1. ')
            useroptions.cw = 0;
    end
    
    
    
    for indexofscenes = 1:maxindexofscenes
        
        parsk = setparsk(datavar_(1,1).skelldef, 'init', []); %hmmm..
        simvar_ = setsimvar(parsk,setparsc('init',[]),useroptions);
        
        for simvaridx = 1:length(simvar_)
            simvar_(simvaridx) = runcore(simvar_(simvaridx),datavar_(indexofscenes,:));
            time = toc(myticvar);
            
            try
                b = evalin('base',['outcomes(indexofscenes)' num2str(simvar_(simvaridx).pc)]);
            catch
                b = struct();
            end
            %
            [b.a, b.b] = simvar_(simvaridx).analyze_outcomes;
            % %simvar = '';
            % assignin('base', ['outcomes' num2str(simvar.pc)], b);
            % assignin('base', 'myidxs',simvar.Alldata);
            % % if params.PLOTIT
            % %     for j = 1:size(simvar.trial,2)
            % %         for i = 1:size(simvar.trial(j).metrics,1)
            % %             figure
            % %             %plotconf(simvar.metrics(i,[2,4])) % replace 5 for : to get all the output
            % %             plotconf(simvar.trial(j).metrics(i,end)) % replace 5 for : to get all the output
            % %
            % %         end
            % %     end
            % % end
            
            if 1
                
                outcomes(indexofscenes).b = b;
                outcomes(indexofscenes).trials = simvar_(simvaridx);
                outcomes(indexofscenes).pcid = datavar_(1,1).pc;
                outcomes(indexofscenes).idxs = datavar_(1,1).Alldata;%pcspecs.idxs;
                outcomes(indexofscenes).hash = datavar_(1,1).env.currhash;
                outcomes(indexofscenes).datavar = datavar_;
            else
                disp('=====================================================================================================================================================================')
                disp('=====================================================================================================================================================================')
                simvar_(simvaridx)
                disp('=====================================================================================================================================================================')
                disp('end accuracy reached')
                disp(b.a)
                disp('=====================================================================================================================================================================')
                disp('=====================================================================================================================================================================')
                clear outcomes
                outcomes = b.a;
            end
            if savesimvar
                sss = whos('simvar_');
                if sss.bytes>10e8
                    warning(['The variable you want to save is ' num2str(sss.bytes) ' in size. I will save it, but you will quickly run out of space.' ])
                end
                save([datavar_(1,1).env.allmatpath 'outcomes' datavar_(1,1).env.SLASH datavar_(1,1).env.currhash '-SIMVAR+outcomes-' num2str(datavar_(1,1).pc)], 'simvar_')
                for i = 1:length(outcomes)
                    a = outcomes(i);
                    save(['../' scene{i} precon num2str(simvaridx)],'a')
                end
            end
            
            
        end
    end
    cacc = [];
    for i =1:length(outcomes)
        cacc = [outcomes(i).b.a cacc];
    end
    cacc = mean(cacc);
    sendfinishjobmail('Classifier finished',['maximum accuracy achieved:' num2str(cacc)],passwd)
catch ME
    disp(ME)
    sendfinishjobmail('error!',['failed when running. check console output for more details. Reason:' ME.message  ],passwd)
end
%combineoutcomes %%broken.
