%The main function

function [kp,ki,kd,IAE,performance,x0] = optimalpid2nd

%Simulated Annealing
% options = saoptimset('MaxFunEvals',4000,'TemperatureFcn',@temperatureboltz,'AnnealingFcn',@annealingboltz);
% [x,IAE,~,output] = simulannealbnd(@(x)isecomp(x),[100 100],[50;50],[50;500],options);%,@(x)horu(x));%,options);

%Genetic algorithm

% options = gaoptimset('Generations',20,'PopulationSize',20);
% [x,IAE,~,output] = ga(@(x)isecomp(x),2,[],[],[],[],[100;0],[550;500],[],[],options);%,@(x)horu(x));%,options);

options = psoptimset('MaxFunEvals',4000);
x0 = [randi([0,20]) randi([0,20]) randi([0,20])];
[x,IAE,~,output] = patternsearch(@(x)isecomp(x),x0,[],[],[],[],[0;0;0],[10;10;10],[],options);%,@(x)horu(x));%,options);

kp = x(1);
ki = x(2);
kd = x(3);
performance = output;

end

% function [c,ceq] = horu(x)
% 
% ceq = [];
% c = [-(x(2)/50 - 3/10)*(x(1) - x(2)/5 - 7/25)+x(2);-(x(2)/50 - 3/10);-(x(1) - x(2)/5 - 7/25);-x(2);-x(1)];
% %
% end

%Nested function to compute de energy for simulated annealing algorithm
function f = isecomp(x)

%plot(x(1),x(2),'ok');
%secorderpid2nd
set_param('secorderpid2nd/Proportional','Gain',num2str(x(1)))
set_param('secorderpid2nd/Integral','Gain',num2str(x(2)))
set_param('secorderpid2nd/Derivative','Gain',num2str(x(3)))
sim('secorderpid2nd.slx');

f = IAE(length(IAE))

end