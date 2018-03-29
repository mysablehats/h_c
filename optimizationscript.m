%optimscript
x1 = [1,1,1];
x2 = [15000,100,1000]; %% if it is too much reduce stufffs
options = optimset('PlotFcns',@optimplotfval);
[x,fval,exitflag,output] = fminbnd(@funfun,x1,x2,options)
