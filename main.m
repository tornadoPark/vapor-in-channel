clear all
close all

global dt
global dx
global NoNodes
global lTot

global CHeat
global AHeat

global TSat
global Rg
global lambdaS
global lambdaL
global rhoS
global cS

global pScale
global ThetaScale
global tScale
global rhoScale

global JaOverPr
global areaRatio
global pressureGradientRatio
global PeSolid
global PeLiquid

global xi
global epsilon

global rhoL

global n

global ventTime
%%%%%%%%%%%%%%% heat flux of this simulation
q = 4e5;
%%%%%%%%%%%%%%%

lTot = 7.2e-3;
A =  4.32e-7;                   % m2, area of tube section
C =  5.6e-3;                    % perimeter


K = 8.33e-10;                   % permeability CFD
% K = 7.85e-10;                 % permeability CFD
% K = 2* 0.0702032 * (1e-4)^2;  % permeability square tube analytical solution 
% epsilon^2 * lTot^2 / 8 ;      % permeability circle tube analytical solution 


AH = 0.025 * A;                 % horizotal geom parameters
lH = 0.5 * lTot;
KH = 1 * K;
RB = 3e-3;                      % radius of attached bubble

CHeat =5.60e-3;                 % perimeter of heated perimeter
AHeat = 3.08e-6;                % area of heated 



iota = 0.013399;                % temperature scale over sat temperature, 5/373.15
% zeta should be determined by p&l initial conditon cause zeta is the ratio of film thicnkness and lTot


epsilon = 9.26e-3;              % curvature radius over total length, contact angle = 50 degree
xi = RB/lTot;

          
hFG = 2180570.606;              % physical properties
muL = 0.000223904;
muG = 1.3167e-5;
rhoL = 936.58;
Rg = 461.637;
sigma = 53.47 * 1e-3;
lambdaS = 130/3;                % averaged conductivity 
lambdaL = 681 * 1e-3;
rhoS = 2329;
cS = 0.75*1000;

TSat = 100 + 273.15;
pScale = sigma/(40e-6);         % ? cannot understand
ThetaScale = 5;
tScale = lTot/400;              % ridiculous
lScale = lTot;
mScale = rhoL*A*lTot;
rhoScale = rhoL;
% deltaScale should be determined using film thickness of 1st time step

%% spatial & temporal discritization
dt = 0.1;
NoNodes = 2000;
dx = 1/NoNodes;                 % non-dimension total length = 1

%% initialization
p(1) = 0.106 *1e6/pScale;       % how to determine?

l(1) = 0.03; 
%p(2) = 0.95*p(1);% actually, p2/p1 = (2*l1 - u2*dt)/l1, but it isn't so necessary, we can try different p2/p1 to fit the u1 in experiments
u2 = 1.5e-3;                    % non-dimension velocity

p(2) = p(1) * (l(1) - u2*dt)/l(1);                      % determined by the equation 
l(2) = (2*l(1)*p(1) - l(1)*p(2))/p(1);                  % as above 
u = [];
u(2) = (l(2)-l(1))/dt;                                  % as above 

% zeta = epsilon*0.67* ((muL*(lScale/tScale)/sigma)^(2/3)) * (0.0015^(2/3));    % Bretherton formula
% zeta = (50/7200)*0.67* ((muL*(lScale/tScale)/sigma)^(2/3)) * (u2^(2/3));
caTemp = muL *u2 * (lScale/tScale) / sigma;
zeta = (50/7200) * (1.34*caTemp^(2/3)) / (1 + 3.35*caTemp^(2/3));               % new formula in paper
deltaScale = zeta * lScale; 

m0 = l(1)*lScale*A*getRho(p(1))/mScale;
m(1) = m0;
m(2) = m(1);
Theta(1) = getTheta(p(1));
Theta(2) = Theta(1);
% thetaW = linspace(8/5,-8/5,NoNodes)'.*ones(NoNodes,1);%0.39239*ones(NoNodes,1); % wall temp initialization using gas temperature of time 0
for nodeIniTemp = 1:NoNodes
   xIniTemp = (nodeIniTemp/NoNodes)*lTot;
   thetaW(nodeIniTemp) = getIniTemp(xIniTemp);          % initial wall temp using fin analytical solution 
end

% upper case "Theta" means excess temp of gas
% lower case with a "W",ie. "thetaW" means excess temp of wall



delta1 = 1e6 * ones(1,NoNodes);                         % initial film thickness is set as a huge value
delta = delta1;                                         % delta of time step 2 and is also delta of time step NOW

%% non-dimensional number
We = epsilon * lTot * rhoL * Rg * TSat / sigma;
Ca = epsilon * muL * lTot * lTot * sqrt(Rg*TSat) / K / sigma;

JaOverPr = ThetaScale*lambdaL/(hFG*rhoL*zeta*zeta*lTot*sqrt(Rg*TSat));
areaRatio = C*(lTot/NoNodes)*zeta/A;
pressureGradientRatio = (AH/A) * (sigma/lTot/lH) * (KH/muG/sqrt(Rg*TSat)) * (1/xi/epsilon);
PeSolid = lambdaS/(rhoS*cS*lTot*sqrt(Rg*TSat));
PeLiquid = lambdaL*CHeat/(rhoS*cS*zeta*AHeat*sqrt(Rg*TSat));


global dmdtEvapSave
global dmdtVentSave


dThetadtSave = [];
dmdtSave = [];
dmdtEvapSave = [];
dmdtVentSave = [];
deltaSave = [];
thetaWSave = [];
dudt = [];


for n = 2 : 15000
    n
    % solve length  (eq1)
    l(n+1) = ((p(n)-78)/(1-l(n)) + Ca*l(n)/dt -We*l(n-1)/dt/dt + 2*We*l(n)/dt/dt)/(We/dt/dt + Ca/dt);
    lNode0 = floor(l(n)/dx);
    lNode1 = floor(l(n+1)/dx);
    u(n+1) = (l(n+1)-l(n))/dt;

    dudt(n+1) = (l(n+1) - 2*l(n) + l(n-1))/dt/dt;

    if l(n+1) >1 | (l(n+1)<l(n) & l(n+1)<1*l(1))
        disp('length break')
        disp(l(n+1))
        break;
    end
    
    
    % solve Theta
    Theta(n+1) = getTheta(p(n));
    % Theta(n+1) = Theta(1);
    
    % solve Theta derivate
    dThetadt = (Theta(n+1) - Theta(n))/dt;
    dThetadtSave = [dThetadtSave,dThetadt];
    
    
    % solve wall temperature (eq4)
    thetaW = getWallTemperature(thetaW,Theta(n+1),delta,q);
    thetaWSave = [thetaWSave,thetaW];
    
    % solve delta (eq5)
    delta0 = delta; % save last time step value will be used in getMassDerivate
    if lNode1 >0
        delta = getDelta(thetaW,Theta(n),Theta(n+1),delta0,lNode0,lNode1); % delta(n+1) in last(scalar) version
    end
    if mod(n,1) == 0
        deltaSave = [deltaSave;delta];
    end
    
    
    % solve mass derivate (eq7)
    dmdt = getMassDerivate(delta0,delta,l(n+1),p(n));
    dmdtSave = [dmdtSave,dmdt];
    
    % solve mass
    % m1 = getMass(l(n),p(n));
    m1 = m(n) + dmdt;
    m(n+1) = m1;

    
    % solve pressure (eq8)
    sourceTerm = We*dmdt + iota*We*(Theta(n+1)*dmdt + m(n+1)*dThetadt); % full form
    % sourceTerm = We*dmdt + iota*We*(m(n+1)*dThetadt); %(temperature term ignored)
    % sourceTerm = iota*We*m(n+1)*dThetadt; % temperature change alone
    % sourceTerm = We*dmdt; % mass change alone (iota term ignored)
    % sourceTerm = 0; % ideal gas (no mass change & no temperature change)
    
    p(n+1) = (sourceTerm + p(n)*l(n+1)/dt) / ((l(n+1)-l(n))/dt + l(n+1)/dt);


    
end

% valuesOfConcern
% figuresOfConcern

