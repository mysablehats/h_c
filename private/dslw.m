function [d,r] = dslw()
%% hopefully slightly faster, since i don't load things all the time. 
try
    d = evalin('base','datavar');
    r = evalin('base','runparsd');
catch
    currpwd = pwd;
    cd ..
    addpath('utils_matlab','dsl')
    cd(currpwd)
    [d,r] = dsl;
    assignin('base','datavar',d)
    assignin('base','runparsd',r)
end