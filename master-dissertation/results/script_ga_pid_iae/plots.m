function plots(melhor_individuo,M,C,K,B,d,tau,w,Ms,simulink)
     % Plot Niquist
    
     

    
    % Plot Poles
    legend boxoff
    s=tf('s');
    Hchapeu=inv(M*s^2+C*s+K+B*d*(kp+(ki/s)+(kd*s))*exp(-s*tau));
    p=pole(pade(Hchapeu,3));
    disp(p)
    figure(2)
    plot(real(p),imag(p),'x')
    hold on
    xlabel('Re','FontSize', 12,'Interpreter','latex')
    ylabel('Im','FontSize', 12,'Interpreter','latex')
    %title('Closed Loop Poles','interpreter','latex')
    title('Polos de malha fechada','interpreter','latex')
    %legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')
    legend({'Polos de malha fechada','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')
    
    % Plot Simulation
    figure(3)
    resposta_no_tempo(melhor_individuo, simulink);
end