function [ dmdt ] = getMassDerivate( delta0,delta1,l1,p0 )

global pScale
global areaRatio
global pressureGradientRatio
global dt
global rhoL
global xi
global epsilon
global n
global tScale
global NoNodes


global dmdtEvapSave
global dmdtVentSave

global ventTime

coeffManualEvap = 1;
dmdtEvap = 0;
for i = 1:NoNodes
	if delta1(i) <= 1 & delta1(i) > 0.05% e.g. 50nm
		if delta0(i) <= 10;% means it is not the NEW film
		dmdtEvap = dmdtEvap - areaRatio*(delta1(i) - delta0(i))/dt;
        end	
	end
end
dmdtEvap = dmdtEvap * coeffManualEvap;



coeffManualVent = 1;
ventTime = 4e-4;
if n*dt*tScale < ventTime
	dmdtVent = 0;
else
	pDim = p0 * pScale / 1e6;
	rhoDim = 5.1711 * pDim + 0.0873;           %  kg/m3
	rho = rhoDim/rhoL;  
	
	dmdtVent = pressureGradientRatio * rho * (xi*p0 - 2*epsilon - 75*xi);
	%%%%%%%%%
	%notice!!!! in last lines p(n) is used instead of p(n+1)
	%%%%%%%%%

	if dmdtVent <= 0
		dmdtVent = 0;
	end
end
dmdtVent = dmdtVent * coeffManualVent;

dmdt = dmdtEvap -  dmdtVent ;

dmdtEvapSave = [dmdtEvapSave,dmdtEvap];
dmdtVentSave = [dmdtVentSave,dmdtVent];


end