function [ oups, oy, odist ] = cond_inp( inps,iy, idist, conds, skelldef )
%cond_inp Conditions input data for each layer of the classifier
%   This function is supposed to read arq_conn and go through all the
%   conditioning arguments and apply them to the input after it is
%   concatenated. THis should allow for the removal of doubled states - as
%   required by cipittelli's classifier and for angle preserving flipping
%   of skeleton sequences. 
confuns = [];
oups = inps;
oy = iy;
odist = idist;
for i = 1:length(conds)
    switch conds{i}
        case 'ms'
            confuns{i} = @mirrorsagittal; 
            oy = [iy iy];
            odist = [idist idist];
            oups.input_ends = [inps.input_ends inps.input_ends];
            if ~isempty(inps.oldwhotokill)
                error('Oldwhotokill is being used and the sagittal mirroring was not prepared to deal with it. It is probably just a matter of repeating the indexes with an offset, but this was not implemented and the algorithm will fail.')
            else 
                oups.oldwhotokill = inps.oldwhotokill; 
            end
            % do these mirrored data require a new index or not? At the
            % moment i don't think so, so i will just copy them over
            if 1
                oups.index = [inps.index inps.index];                
            else % the alternative is
                oups.index = [inps.index inps.index+size(inps.index,2)];
            end
            oups.awk = inps.awk;
        case 'rd'
            confuns{i} = @removedoubled;
            skelldef.repeat = 'last';
        case 'rds'
            confuns{i} = @removedoubled;
            skelldef.repeat = 'zeros';
        otherwise
            error('wrong argument in cond_inpu: unrecognized conditioning procedure')
    end
end
skelldef.ic = @inv_core;
for j = confuns
    dbgmsg(['Applying ' j ' to input'])
    if isequal(inps.input,inps.input_clip)
        inp = zeros(size(inps.input));
        [~,outf] = j{:}(inps.input(:,1),skelldef);
        out = repmat(outf,size(inps.input,2),1);
        for k = 1:size(inp,2) % check it
            [inp(:,k),out(k)] = j{:}(inps.input(:,k),skelldef);
        end
        inpC = inp;
        if 0
            for ii = 1:size(inps.input,2)
                ihca(ii,:) = out(ii).initialhipchestangle;
                ehca(ii,:) = out(ii).endhipchestangle;
                iha(ii,:) = out(ii).initialheadangle;
                eha(ii,:) = out(ii).endheadangle;
                ehcar(ii,:) = out(ii).endhipchestanglerho;
                ehar(ii,:) = out(ii).endheadanglerho;
            end
            a = vec2ind(iy);
            figure
            scatter3(ihca(:,1), ihca(:,2), ihca(:,3),2,a )
            hold on
            scatter3(iha(:,1), iha(:,2), iha(:,3),2,a )
            figure
            scatter3(ehca(:,1), ehca(:,2), ehca(:,3),2,a )
            hold on
            scatter3(eha(:,1), eha(:,2), eha(:,3),2,a )
            figure
            scatter3(ehcar(:,1), ehcar(:,2), ehcar(:,3),2,a )
            hold on
            scatter3(ehar(:,1), ehar(:,2), ehar(:,3),2,a )
        end
    else
        warning('check if input and input_clip are both necessary. this function is performing actions on both and could run twice as fast if only one of that needs to be conditioned.')
        inp = zeros(size(inps.input));
        inpC = zeros(size(inps.input_clip));
        [~,outf] = j{:}(inps.input(:,1),skelldef);
        out = repmat(outf,size(inps.input,2),1);
        outC = repmat(outf,size(inps.input_clip,2),1);
        for k = 1:size(inp,2) % check it
            [inp(:,k),out(k)] = j{:}(inps.input(:,k),skelldef);
            [inpC(:,k),outC(k)] = j{:}(inps.input_clip(:,k),skelldef);
        end
    end
    if isequal(j{:},@mirrorsagittal)
        oups.input_clip = [inps.input_clip inpC];
        oups.input = [inps.input inp];
    end
end
end
function [inpk,out] = mirrorsagittal(inpk,skelldef)
%%% old notation says this should be a tensor. since i am not getting the
%%% layer type, i will not try to guess what this is. for velocities also
%%% this will be completely messed up, since i should actually create a
%%% angle of shift vector from positions and use that to flip velocities. 
%%% Actually the whole angle vector might be interesting to create, since I
%%% want to know if that carries a lot of information or not. 
[inpks,out] =cond_MS_(reshape(inpk,[],3),skelldef);
 inpk = reshape(inpks,[],1);
end
function [outk, out] = removedoubled(inpk,skelldef)
out = nan;
outk(1) = inpk(1);
j = 1;
for i = 2:length(inpk)
    if inpk(i)~=outk(end)
        j = j+1;
        outk(j) = inpk(i);
    end
end
switch skelldef.repeat
    case 'zeros'
        repm = 0;
    case 'same'
        repm = outk(end);
end 

%%% so that we have all completely filled vectors
fillermat = repmat(repm,length(inpk)-length(outk),1);
try
outk = [outk.';fillermat];
catch
    disp('hi')
end
%error('not implemented yet')
end


