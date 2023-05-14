function [ delta1 ] = getDelta( thetaW,Theta0,Theta1,delta0,lNode0,lNode1)

global JaOverPr
global dt
global NoNodes

global n

% Theta(n+1),delta(n) usd in discretized
% delta1 = (-JaOverPr*(1-Theta1)/delta0 + delta0/dt) * dt;

%if 0 % Theta0>thetaW(1) || Theta1 >thetaW(1)
	%delta1 = delta0;

if n == 2
	lNode0 = 0;

end

if lNode1 >= lNode0 % bubble expansion
	for i = 1:lNode0
		% assign 0 for too thin film
		if delta0(i) <= 0.05% e.g. 50nm
			delta1(i) = 0;
			continue;
		end

		% thinning
		if thetaW(i)>Theta1
			delta1(i) = (-JaOverPr*(thetaW(i)-Theta1)/delta0(i) + delta0(i)/dt) * dt;
			if delta1(i) <= 0.05% e.g. 50nm
			delta1(i) = 0;
            end	
		else
			delta1(i) = delta0(i);

		end
	end
	for i = (lNode0+1):lNode1
		delta1(i) = 1;
	end
	for i = (lNode1+1):NoNodes
		delta1(i) = 1e6;% a huge number
	end

else % bubble contraction
	for i = 1:lNode1
		% assign 0 for too thin film
		if delta0(i) <= 0.05% e.g. 50nm
			delta1(i) = 0;
			continue;
		end
		% thinning
		if thetaW(i)>Theta1
			delta1(i) = (-JaOverPr*(thetaW(i)-Theta1)/delta0(i) + delta0(i)/dt) * dt;
		else
			delta1(i) = delta0(i);
		end
	end
	for i = (lNode1+1):NoNodes
		delta1(i) = 1e6;% a huge number
	end
end
end