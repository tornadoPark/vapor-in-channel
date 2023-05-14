function [y] = getIniTemp (x)

global ThetaScale

h = 82050;

% y = (0.39*5+100-92)*cosh(4.68656*(h^0.5)*(x-0.0072))*sech(0.0337432*(h^0.5));
y = (4+100-92)*cosh(4.68656*(h^0.5)*(x-0.0072))*sech(0.0337432*(h^0.5));
y = (y-8) / ThetaScale;

end
