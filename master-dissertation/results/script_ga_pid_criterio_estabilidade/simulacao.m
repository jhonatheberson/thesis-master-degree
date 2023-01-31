

%plot(x(1),x(2),'ok');
%secorderpid2nd
set_param('secorderpid2nd/Proportional','Gain',num2str(melhor_individuo(1)))
set_param('secorderpid2nd/Integral','Gain',num2str(melhor_individuo(2)))
set_param('secorderpid2nd/Derivative','Gain',num2str(melhor_individuo(3)))
sim('secorderpid2nd.slx');

f = IAE(length(IAE))
