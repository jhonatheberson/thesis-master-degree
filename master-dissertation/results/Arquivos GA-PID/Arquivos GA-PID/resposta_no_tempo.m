function resposta_no_tempo(melhor_individuo, simulink)
    % Set Params PID
    SimOut=sim('SimulacaoPID','ReturnWorkspaceOutputs', 'on');
    % Run Simulation
    sim(simulink);
    % Plot Simulation
    plot(SimOut.tempo,SimOut.estados_x(:,1),'--','linewidth',2.0)
    xlabel('$Tempo (s)$','FontSize', 10,'Interpreter','latex')
    ylabel('$Sinal$','FontSize', 10,'Interpreter','latex')
    hold on
    plot(SimOut.tempo,SimOut.estados_x(:,2),'-','linewidth',2.0)
    legend('Referência','Sinal')
    title('simulação do sistema')
end
