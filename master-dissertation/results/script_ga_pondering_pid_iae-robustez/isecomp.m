function f = isecomp(melhor_individuo,simulink)
    % Set Params PID
    set_param(strcat(simulink,'/Proportional'),'Gain',num2str(melhor_individuo(1)))
    set_param(strcat(simulink,'/Integral'),'Gain',num2str(melhor_individuo(2)))
    set_param(strcat(simulink,'/Derivative'),'Gain',num2str(melhor_individuo(3)))
    % Run Simulation
    sim(simulink);
    f = IAE(length(IAE));
end