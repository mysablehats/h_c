function [actionstructure,flag_set] = complicated_concatenator(actionstructure,m,shortdim,q,r,p,flag_set)

for j = 1:1+p:actionstructure.end
    a = zeros(shortdim*q,1,class(actionstructure.pose));
    indexx = zeros(1,q,class(actionstructure.index));
    dist = 0;
    sizeofchunk = j+q*r-1;
    if sizeofchunk>size(actionstructure.pose,2)
        if ~flag_set
            flag_set = true;
            warning('cant complete the whole vector! Will pad with nans. This is an important warning!!!! It will have very unpredictable consequences in end results!!!!!!!!!!!!!!!!!!!!!!')
        end
        %%% better options for this padding include a mean, or maybe
        %%% just continue the structure over itself and loop it around,
        %%% like a regular tiling
        actionstructure.index = [actionstructure.index nan(size(actionstructure.index,1),q)];
        actionstructure.dist = [actionstructure.dist nan(size(actionstructure.dist,1),q)];
        actionstructure.pose = [actionstructure.pose nan(size(actionstructure.pose,1),q)];
        %%% this should not be horrible because m will not flip over to
        %%% a new sample, since we didn't update the ends
        %break
    end
    k = 1;
    for lop = 1:q
        a(1+(k-1)*shortdim:k*shortdim) = actionstructure.pose(:,j+lop*r-1);
        indexx(lop) = actionstructure.index(j+lop*r-1);
        dist = dist + actionstructure.dist(j+lop*r-1);
        k = k+1;
    end
    
    %have to save a somewhere
    actionstructure.long(m).vec = a;
    actionstructure.long(m).index = indexx;
    actionstructure.long(m).dist = dist;
    m = m+1;
end
end