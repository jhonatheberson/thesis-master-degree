%The main function


function [kp,ki,kd,IAE,performance,x0] = optimalpid2nd(M,C,K,b,d,tau,w,Ms)
warning off
%Simulated Annealing
% options = saoptimset('MaxFunEvals',4000,'TemperatureFcn',@temperatureboltz,'AnnealingFcn',@annealingboltz);
% [x,IAE,~,output] = simulannealbnd(@(x)isecomp(x),[100 100],[50;50],[50;500],options);%,@(x)horu(x));%,options);


% funcao_objetivo=0;
%     while funcao_objetivo==0
x0 = [randi([0,20]) randi([0,20]) randi([0,20])];
%     L=L_ponto_a_ponto(M,C,K,b,d,tau,w,x0);
%     ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
%     disp(['ff:  ', num2str(ff)])
%     c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
%     disp(['c:  ', num2str(c)])
%         if (ff<0.5 && c<0.9)
%             funcao_objetivo=1;
%             disp(['entrou dentro da condição:  ', num2str(ff)])
%nonlcon = @(x,M,C,K,b,d,tau,w,Ms)creterian(x,M,C,K,b,d,tau,w,Ms);

options = psoptimset('MaxFunEvals',4000);
%options = optimoptions('patternsearch','Display','iter','PlotFcn',@psplotbestf);
[x,IAE,~,output] = patternsearch(@(x)isecomp(x),x0,[],[],[],[],[0;0;0],[10;10;10],@(x,M,C,K,b,d,tau,w,Ms)creterian(x,M,C,K,b,d,tau,w,Ms),options);%,@(x)horu(x));%,options);

kp = x(1);
ki = x(2);
kd = x(3);
performance = output;

%end
    %end
%Genetic algorithm

%options = gaoptimset('Generations',20,'PopulationSize',3);
%[x,IAE,~,output] = ga(@(x)isecomp(x),3,[],[],[],[],[100;0],[550;500],[],[],options);%,@(x)horu(x));%,options);



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

function [c, ceq] = creterian(x,M,C,K,b,d,tau,w,Ms)
    L=L_ponto_a_ponto(M,C,K,b,d,tau,w,x);
    ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
    distance=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
    c = distance - 0.9;
    ceq = [];
end