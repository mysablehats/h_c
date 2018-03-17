function [sstgasj, sstv] = gas_method2(sstgas, sstv, vot, arq_connect,j,k)
dimdim = 1;
%% Gas Method
% This is a function to go over a gas of the classifier, populate it with the apropriate input and generate the best matching units for the next layer.
%% Setting up some labels
sstgasj = sstgas(j);
sstgasj.name = arq_connect.name;
sstgasj.method = arq_connect.method;
sstgasj.layertype = arq_connect.layertype;
arq_connect.params.layertype = arq_connect.layertype;
arq_connect.params.skelldef.currlayer = arq_connect.layertype; %%% i am copying this everywhere, i should probably put it in a more convinient place. also this is also being overwritten now 

%% Choosing the right input for this layer
% This calls the function set input that chooses what will be written on the .inputs variable. It also handles the sliding window concatenations and saves the .input_ends properties, so that this can be done recursevely.
% After some consideration, I have decided that all of the long inputing
% will be done inside setinput, because it it would be easier.
dbgmsg('Working on : ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,' for process:',num2str(labindex),0)

[sstv.gas(j).inputs.input_clip, sstv.gas(j).inputs.input, sstv.gas(j).inputs.input_ends, sstv.gas(j).y, sstv.gas(j).inputs.oldwhotokill, sstv.gas(j).inputs.index, sstv.gas(j).inputs.awk, sstv.gas(j).distances(k,:)]  = setinput(arq_connect, sstgas, dimdim, sstv,k); %%%%%%

%% applying whatever function to it
if strcmp(vot, 'train')
    dbgmsg('applying conditioning functions to training set')
    [sstv.gas(j).inputs, sstv.gas(j).y, sstv.gas(j).distances] = cond_inp(sstv.gas(j).inputs,sstv.gas(j).y, sstv.gas(j).distances ,arq_connect.input_cond{1}, arq_connect.params.skelldef  );
end
if strcmp(vot, 'val')
    dbgmsg('applying conditioning functions to validation set')
    [sstv.gas(j).inputs, sstv.gas(j).y, sstv.gas(j).distances]= cond_inp(sstv.gas(j).inputs,sstv.gas(j).y, sstv.gas(j).distances ,arq_connect.input_cond{2}, arq_connect.params.skelldef  );
end
%%
% After setting the input, we can actually run the gas, either a GNG or the
% GWR function we wrote.

switch arq_connect.method
    case {'gng','gwr'}'
        if strcmp(vot, 'train')
            dbgmsg('Working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,' for process:',num2str(labindex),0)
            %DO GNG OR GWR
            [sstgasj.nodes, sstgasj.edges, sstgasj.outparams, sstgasj.gasgas] = gas_wrapper(sstv.gas(j).inputs.input_clip,arq_connect);
            %%%% POS-MESSAGE
            dbgmsg('Finished working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,'.Num of nodes reached:',num2str(sstgasj.outparams.graph.nodesvect(end)),' for process:',num2str(labindex),0)
        end               
        %% Best-matching units
        % The last part is actually finding the best matching units for the gas.
        % This is a simple procedure where we just find from the gas units (nodes
        % or vectors, as you wish to call them), which one is more like our input.
        % It is a filter of sorts, and the bestmatch matrix is highly repetitive.
        
        % I questioned if I actually need to compute this matrix here or maybe
        % inside the setinput function. But I think this doesnt really matter.
        % Well, for the last gas it does make a difference, since these units will
        % not be used... Still I will  not fix it unless I have to.
        %PRE MESSAGE
        dbgmsg('Finding best matching units for gas: ''',sstgasj.name,''' (', num2str(j),') for process:',num2str(labindex),0)
        [sstv.gas(j).distances(k,:), ~, sstv.gas(j).bestmatchbyindex(k,:)] = genbestmmatrix(sstgasj.nodes, sstv.gas(j).inputs.input, sstv.gas(j).inputs.awk, sstv.gas(j).distances(k,:), arq_connect.layertype, arq_connect.q, arq_connect.params.distancetype, sstgasj.gasgas); %assuming the best matching node always comes from initial dataset!
        
    case 'som'
        [sstgasj.nodes, sstgasj.edges, sstgasj.outparams, sstgasj.gasgas, sstv.gas(j).distances(k,:), sstv.gas(j).bestmatchbyindex(k,:)] = som_wrapper(sstv.gas(j).inputs.input_clip, arq_connect);
        warning('maybe undefined variables')
    case 'knn'
        sstgasj.nodes = sstv.gas(j).inputs.input_clip;
        warning('maybe undefined variables')     
    case 'kme'
         dbgmsg('Running K-means algorithm with ', num2str(arq_connect.params.nodes),' nodes.',1)
         [ sstv.gas(j).bestmatchbyindex(k,:), nodesnodes, ~,  distdist ] = kmeans(sstv.gas(j).inputs.input_clip.', arq_connect.params.nodes  );
         sstgasj.nodes = nodesnodes.';
         sstv.gas(j).distances(k,:) = min(distdist.');
         %[ sstv.gas(j).bestmatchbyindex(k,:), sstgasj.nodes, ~, distdist ] = kmeans(sstv.gas(j).inputs.input_clip.', arq_connect.params.nodes  );
    otherwise
        error('method nod defined.')
end

%% Post-conditioning function
%This will be the noise removing function. I want this to be optional or allow other things to be done to the data and I
%am still thinking about how to do it. Right now I will just create the
%whattokill property and let setinput deal with it.
if arq_connect.params.oldremovepoints
    dbgmsg('Flagging noisy input for removal from gas: ''',sstgasj.name,''' (', num2str(j),') with points with more than',num2str(arq_connect.params.gamma),' standard deviations, for process:',num2str(labindex),0)
    sstv.gas(j).whotokill = removenoise(sstgasj.nodes, sstv.gas(j).inputs.input, sstv.gas(j).inputs.oldwhotokill, arq_connect.params.gamma, sstv.gas(j).inputs.index);
else
    dbgmsg('Skipping removal of noisy input for gas:',sstgasj.name,0)
end
end