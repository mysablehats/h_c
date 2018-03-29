function y= funfun(x)
% if nargin ==0
% y = 0;
% else
x = floor(x); % because, erm my stuff can't deal with floats
[~,y] = cl_(x(1),x(2),x(3)); 
y = -y; % because it is a min search...
end