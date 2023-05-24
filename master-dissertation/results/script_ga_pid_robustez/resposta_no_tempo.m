function resposta_no_tempo(melhor_individuo, simulink)
    % Set Params PID
    set_param(strcat(simulink,'/Proportional'),'Gain',num2str(melhor_individuo(1)))
    set_param(strcat(simulink,'/Integral'),'Gain',num2str(melhor_individuo(2)))
    set_param(strcat(simulink,'/Derivative'),'Gain',num2str(melhor_individuo(3)))
    % Run Simulation
    sim(simulink);
    % Plot Simulation
    plot(tempo,estados_x(:,1),'r--','linewidth',1.5)
    axis([0 60 00 1.4])
    xlabel('$Tempo (s)$','FontSize', 10,'Interpreter','latex')
    ylabel('$Sinal$','FontSize', 10,'Interpreter','latex')
    hold on
    plot(tempo,estados_x(:,2),'b-','linewidth',1.5)
    legend({'$r(t)$','$y(t)$ - Robustez'}, 'interpreter','latex')
    title('simulação do sistema')
end
