function idx = flipindexes(skelldef,q,layertype)

%idx = [];
part = 16:30;
ln = skelldef.length/2 ;

if strcmp(layertype,'all')
    %ln = skelldef.length ;
    addst = repmat(part,q(1)*2,1);
else
    
    addst = repmat(part,q(1),1);
end

for i =1:size(addst,1)
    addst(i,:) = addst(i,:) + ln*(i-1);
end

idx = reshape(addst,1,[]);
end 