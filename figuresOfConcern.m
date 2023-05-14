close all


subplot(2,3,1)
plot(p(1:end-1))

hold on
upBound= 1.2*max(p(1:end-1));
lowBound = min(p(1:end-1));
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)
ylim([75 100])
hold off

title('$\bar p \sim \bar t$','interpreter','latex', 'FontSize', 16);

subplot(2,3,2)
plot(l(1,1:end-1))
hold on
upBound= 1.2*max(l(1,1:end-1));
lowBound = min(l(1,1:end-1));
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)





hold off
title('$\bar l \sim \bar t$','interpreter','latex', 'FontSize', 16);

subplot(2,3,3)
plot(Theta(1:end-1))
title('$\bar \theta \sim \bar t$','interpreter','latex', 'FontSize', 16);

subplot(2,3,4)
plot(deltaSave(:,1))
hold on
upBound= 1.2*max(deltaSave(:,1));
lowBound = min(deltaSave(:,1));
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)
hold off
title('$\bar \delta_{bottom} \sim \bar t$','interpreter','latex', 'FontSize', 16);

subplot(2,3,5)
plot(linspace(0,1,NoNodes),thetaW)
title('$\bar \theta_W \sim \bar x$','interpreter','latex', 'FontSize', 16);

subplot(2,3,6)
DeltaT = thetaWSave(1,:) - (-7/ThetaScale);
loglog(q./DeltaT)
title('$htc\sim \bar t$','interpreter','latex', 'FontSize', 16);

subplot(2,3,6)
plot(m)
hold on
upBound= 1.2*max(m);
lowBound = min(m);
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)
hold off
title('$m \sim \bar t$','interpreter','latex', 'FontSize', 16);




% set(gcf,'Position',get(0,'ScreenSize'))

figure

temp = u * lScale/tScale;
plot(temp)
hold on
upBound= 1.2*max(temp);
lowBound = min(temp);
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)
title('dldt')
hold off

figure 

i = 1000;
temp = deltaSave(i,:);
flag = find(deltaSave(i,:)>10);
temp(flag) = 2;
plot([1:2000],temp)
hold on

temp = thetaWSave(:,i) - Theta(i+2);
plot([1:2000],temp)
temp = thetaWSave(:,i);
plot([1:2000],temp)
plot([1:2000],zeros(1,2000))
hold off

figure
plot(dmdtEvapSave)
hold on
plot(dmdtVentSave)
upBound= 1.2*max([dmdtEvapSave,dmdtVentSave]);
lowBound = min([dmdtEvapSave,dmdtVentSave]);
y = linspace(lowBound,upBound,100);
x = ceil(ventTime/tScale/dt)*ones(1,length(y));
plot(x,y)
hold off


