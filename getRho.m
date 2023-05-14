function [ rho ] = getRho( p )

global pScale
global rhoScale

pDim = p * pScale / 1e6;
rhoDim = 5.1711 * pDim + 0.0873;
rho = rhoDim/rhoScale;




end