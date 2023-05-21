function [thetaW] = getIniTemp (x)

global ThetaScale
global CHeat
global AHeat
global lambdaS
global lTot

global h
global deltaTempInExp

% h = 82050; % from RTDs in porous zone, too high compared with experi value (30000 ~ 40000)
% h = 36638; % from experi # 600, q = 3.4e5
% h = 36637;
% deltaTempInExp = 10; % temperature from expei, 92+12 = 104
m = sqrt(h*CHeat/lambdaS/AHeat);
thetaFinBase = deltaTempInExp; % temp in analytical solution is the excess one, not the dimensionless one

% thetaFin = thetaFinBase*cosh(4.68656*(h^0.5)*(x-0.0072))*sech(0.0337432*(h^0.5));
thetaFin = thetaFinBase*cosh(m*(x-0.0072))*sech(m*lTot);

%%%% original comment forget why
% (0.39*5+100-92)*cosh(4.68656*(h^0.5)*(x-0.0072))*sech(0.0337432*(h^0.5));
%%%%
% y = (4+100-92)*cosh(4.68656*(h^0.5)*(x-0.0072))*sech(0.0337432*(h^0.5));

thetaWDim = (thetaFin +92 -100); % excess temp of wall with dimension
thetaW = (thetaWDim) / ThetaScale; % non-dimensionalize

end
