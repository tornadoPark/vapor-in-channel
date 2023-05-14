function thetaW1 = getWallTemperature( thetaW,theta1,delta,q )
% 下时间步的壁面温度 = f(上时间步壁温，下时间步气体温度，上时间步液膜厚，热流)
global dt
global dx
global NoNodes
global lTot
global TSat
global Rg

global ThetaScale

global PeSolid
global PeLiquid

global lambdaS
global lambdaL
global rhoS
global cS


%% 选择计算中使用的气体温度
% 选用下时间步气体温度
theta = theta1;
%%

thetaWCoeffMat = zeros(NoNodes,NoNodes); % claim an empty coeff matrix
thetaWSourVec = zeros(NoNodes,1); % claim an empty source vector

dtConduct = 0.01;

for conductTime = 1:10 % 10*0.01=0.1,即导热时间与外层气体推进时间相等
    for i = 2: (NoNodes-1) % 内部点系数
        thetaWCoeffMat(i,i-1) = PeSolid*dtConduct/(dx^2);
        if delta(i) <= 0.05% e.g. 50nm
            thetaWCoeffMat(i,i) = -1 - 2*PeSolid*dtConduct/(dx^2);
        else
            thetaWCoeffMat(i,i) = -1 - 2*PeSolid*dtConduct/(dx^2) - PeLiquid*dtConduct/delta(i);
        end
        thetaWCoeffMat(i,i+1) = PeSolid*dtConduct/(dx^2);
        if delta(i) <= 0.05% e.g. 50nm
            %i
            thetaWSourVec(i) = -thetaW(i);
        else
            thetaWSourVec(i) = -thetaW(i) - PeLiquid*dtConduct*theta/delta(i);
        end
    end
    
    % boundry conditon
    if delta(1) <= 0.05% e.g. 50nm
        thetaWCoeffMat(1,1) = -1 - PeSolid*dtConduct/(dx^2);
    else
        thetaWCoeffMat(1,1) = -1 - PeSolid*dtConduct/(dx^2) - PeLiquid*dtConduct/delta(i);
    end
    
    thetaWCoeffMat(1,2) = PeSolid*dtConduct/(dx^2);
    
    if delta(1) <= 0.05% e.g. 50nm
        thetaWSourVec(1) = -thetaW(1) - q*(dtConduct/dx)/(rhoS*cS*ThetaScale*sqrt(Rg*TSat));
    else
        thetaWSourVec(1) = -thetaW(1) - PeLiquid*dtConduct*theta/delta(1) - q*(dtConduct/dx)/(rhoS*cS*ThetaScale*sqrt(Rg*TSat));
    end
    
%     thetaWCoeffMat(NoNodes,NoNodes-1) = PeSolid*dtConduct/(dx^2);
%     thetaWCoeffMat(NoNodes,NoNodes) = -1 - PeSolid*dtConduct/(dx^2);
%     thetaWSourVec(NoNodes) = - thetaW(NoNodes);
    thetaWCoeffMat(NoNodes,NoNodes-1) = PeSolid*dtConduct/(dx^2);
    thetaWCoeffMat(NoNodes,NoNodes) = -1 - 3 * PeSolid*dtConduct/(dx^2) - PeLiquid*dtConduct / delta(i);
    thetaWSourVec(NoNodes) = - thetaW(NoNodes) - 2*PeSolid*dtConduct*(-8/5)/dx/dx - PeLiquid*dt*theta/delta(i);
    
    thetaW0 = thetaW(1);
    % solve using TDMA(zhuigan fa)
    thetaW = TDMA(thetaWCoeffMat,thetaWSourVec);
%     if abs(thetaW(1) - thetaW0) <= 1e-6
%         conductTime
%         break;
%     end
    conductTime = conductTime + 1;
    


end



thetaW1 = thetaW;
end
