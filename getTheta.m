function [ y] = getTheta( p )

global pScale;
global ThetaScale;

global TSat;

pDim = p * pScale / 1e6;                             %  MPa
temperDim = -173.37*pDim*pDim + 233.49*pDim + 352.31;   %  K
ThetaDim = temperDim - TSat  ;                          %  K
y = ThetaDim/ThetaScale;                         %  1

end