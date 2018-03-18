function simvar = setsimvar(params,parsc,useroptions)
allc = allconfigs;
simvar = Simvargas(allc.simvar.init);
if isfield(useroptions, 'n')
    dbgmsg('defining number of nodes based on user input:', num2str(useroptions.n))
    simvar.NODES_VECT = useroptions.n;
else
    dbgmsg('defining number of nodes based on configuration files:', num2str(allc.simvar.NODES_VECT))
    simvar.NODES_VECT = allc.simvar.NODES_VECT;
end 
simvar.MAX_EPOCHS_VECT = allc.simvar.MAX_EPOCHS_VECT;
simvar.ARCH_VECT = allc.simvar.ARCH_VECT;
simvar.MAX_NUM_TRIALS = allc.simvar.MAX_NUM_TRIALS;
simvar.MAX_RUNNING_TIME = allc.simvar.MAX_RUNNING_TIME;
simvar = simvar.init(params,parsc,useroptions); %%%%%%%%%%% ? 
%%is there any
%%reason why I should not just start with the correct parameters if I
%%already know them? I don't think so, this was probably a mistake. 
%simvar = simvar.init(allc.params,allc.parsc,useroptions); %%%%%%%%%%% ?
%okay, i need skelldef
%simvar = simvar.init(params,allc.parsc,useroptions); %%%%%%%%%%% ?
%this was not a mistake, this is how it should be - you need to fix other
%parts of the code before fixing this. 

end