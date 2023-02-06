function resposta_no_tempo(melhor_individuo, simulink)
    % Set Params PID
    set_param(strcat(simulink,'/Proportional'),'Gain',num2str(melhor_individuo(1)))
    set_param(strcat(simulink,'/Integral'),'Gain',num2str(melhor_individuo(2)))
    set_param(strcat(simulink,'/Derivative'),'Gain',num2str(melhor_individuo(3)))
    % Run Simulation
    sim(simulink);
    % Plot Simulation
    plot(tempo,estados_x(:,1),'--','linewidth',2.0)
    xlabel('$Tempo (s)$','FontSize', 10,'Interpreter','latex')
    ylabel('$Sinal$','FontSize', 10,'Interpreter','latex')
    hold on
    plot(tempo,estados_x(:,2),'-','linewidth',2.0)
    legend('Referência','Sinal')
    title('simulação do sistema')
end
