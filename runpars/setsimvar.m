function simvar = setsimvar(params,parsc,useroptions)
allc = allconfigs;
simvar = Simvargas(allc.simvar.init);
simvar.NODES_VECT = allc.simvar.NODES_VECT;
simvar.MAX_EPOCHS_VECT = allc.simvar.MAX_EPOCHS_VECT;
simvar.ARCH_VECT = allc.simvar.ARCH_VECT;
simvar.MAX_NUM_TRIALS = allc.simvar.MAX_NUM_TRIALS;
simvar.MAX_RUNNING_TIME = allc.simvar.MAX_RUNNING_TIME;
simvar = simvar.init(params,parsc,useroptions);
end