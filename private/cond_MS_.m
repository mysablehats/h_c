function [newskel, out] = cond_MS_(tdskel, skelldef)
angle = [];
inv_polar = skelldef.ic;
[avp, newskel, ac,iac,av,eha, skelldef] = inv_polar(tdskel, skelldef, angle);
%%%%%%%% test version
out.angle = avp;
out.endheadangle = ac;
out.initialheadangle = iac;
out.initialhipchestangle = av;
out.endhipchestangle = eha;
out.skelldef = skelldef;

%out = angle;
if 0% (avp(1)>0.3&&isequal(inv_polar,@polar_core))||(avp(1)<0.8&&isequal(inv_polar,@inv_core))
    oldpath = addpath('misc','misc\measures');
    figure
    skeldraw(tdskel(1:15,:),'f');hold on;
    rangerange(1,:) = linspace(0,avp(1));
    rangerange(2,:) = linspace(0,avp(2));
    rangerange(3,:) = linspace(0,avp(3));
    arrayofskels = zeros([size(tdskel),100]);
    for i = 1:100
        [~, newskel] = inv_polar(tdskel, skelldef, rangerange(:,i));
        
        arrayofskels(:,:,i) = newskel;
    end
    skeldraw(arrayofskels(1:15,:,:),'W');
    path(oldpath)
end

end


