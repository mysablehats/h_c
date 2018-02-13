function [d,r] = dslw()
%% hopefully slightly faster, since i don't load things all the time. 
try
    d = evalin('base','datavar');
    r = evalin('base','runparsd');
catch
    cd ..
    addpath('utils_matlab','dsl')
    cd cad-gas
    [d,r] = dsl;
    assignin('base','datavar',d)
    assignin('base','runparsd',r)
end