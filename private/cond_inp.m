function [ inp ] = cond_inp( inp, conds )
%cond_inp Conditions input data for each layer of the classifier
%   This function is supposed to read arq_conn and go through all the
%   conditioning arguments and apply them to the input after it is
%   concatenated. THis should allow for the removal of doubled states - as
%   required by cipittelli's classifier and for angle preserving flipping
%   of skeleton sequences. 
confuns = [];
for i = 1:length(conds)
    switch conds{i}
        case 'ms'
            confuns{i} = @mirrorsagittal;            
        case 'rd'
            confuns{i} = @removedoubled;
        otherwise
            error('wrong argument in cond_inpu: unrecognized conditioning procedure')
    end
end
for j = confuns
    dbgmsg(['Applying ' j ' to input'])
    for k = 1:size(inp,2) % check it
        inp(:,k) = j{:}(inp(:,k)); 
    end 
end
end
function inpk = mirrorsagittal(inpk)
disp('hello1')
end
function inpk = removedoubled(inpk)
disp('hello2')
end


