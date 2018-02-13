function dist = flipper(part, x,y)
%disp('hello')
%%%% this function needs skelldef period
%i need to know if it is postion or velocity or all or something custom

% or i can just know q?


%part = 16:30;
x_f = x;
x_f(part) = -x(part);
%slightly optimized
dist = sqrt(min([sum((y-x).*(y-x),2) sum((y-x_f).*(y-x_f),2) ],[],2));
end
