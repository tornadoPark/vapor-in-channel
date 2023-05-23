% velocity0 = (l(2)-l(1))/dt * 400

% pressure0 = p(1)*pScale/1e6

totalTime = dt*length(l)*tScale
lMax = max(l)
pMax = max(p)
HTC_final = q/(thetaWSave(1,end)*ThetaScale+100-92)

% uMean = max(l)/find(l==max(l))

lNon = l';
pDim = (p*pScale)';
deltaBotDim = (deltaSave(:,1)*deltaScale);

% timeStep = [];
% i = 1;
% for time = 1:2:7
%     timeStep(i) = floor(time*1e-3/dt/tScale);
%     i = i+1;
% end
% 
% %% delta v.s. time
% flag = timeStep(2);
% temp = deltaSave(flag,:);
% temp(find(temp > 2)) =[];
% temp = deltaScale*temp';
%     
% %% temperature v.s. time
% flag = timeStep(1);
% temp = thetaWSave(:,flag);
