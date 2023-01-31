function resposta_no_tempo(melhor_individuo, simulink)
set_param('secorderpid2nd/Proportional','Gain',num2str(melhor_individuo(1)))
set_param('secorderpid2nd/Integral','Gain',num2str(melhor_individuo(2)))
set_param('secorderpid2nd/Derivative','Gain',num2str(melhor_individuo(3)))
sim(simulink);



plot(tempo,estados_x(:,1),'--','linewidth',2.0)
xlabel('$Tempo (s)$','FontSize', 10,'Interpreter','latex')
ylabel('$Sinal$','FontSize', 10,'Interpreter','latex')
hold on
plot(tempo,estados_x(:,2),'-','linewidth',2.0)
legend('Referência','Sinal')
title('simulação do sistema')
end
