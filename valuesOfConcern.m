% velocity0 = (l(2)-l(1))/dt * 400

% pressure0 = p(1)*pScale/1e6

totalTime = dt*length(l)*tScale
lMax = max(l)
pMax = max(p)

% uMean = max(l)/find(l==max(l))

% here is the branch of geom