% velocity0 = (l(2)-l(1))/dt * 400

% pressure0 = p(1)*pScale/1e6

totalTime = dt*length(l)*tScale
lMax = max(l)
pMax = max(p)
HTC_final = q/(thetaWSave(1,end)*ThetaScale+100-92)

% uMean = max(l)/find(l==max(l))

% a test for branch
% this is the branch of heat flux