function plots(melhor_individuo,M,C,K,B,d,tau,w,Ms,simulink)
    % Plot Niquist
    kp = melhor_individuo(1);
    ki = melhor_individuo(2);
    kd = melhor_individuo(3);
    L=Lpid(M,C,K,B,d,tau,w,melhor_individuo(1,1:3));
    plot(real(L),imag(L),':','linewidth',1.5)
    box off
    axis([-3 1 -2 2])
    theta=0:1e-2:2*pi;
    x=Ms^-1*cos(theta)-1;
    y=Ms^-1*sin(theta);
    hold on
    plot(x,y,'r','LineWidth',1.5)
    plot(-1,0,'rx','LineWidth',1.5)
    %xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
    xlabel('Eixo Real','FontSize', 12,'Interpreter','latex')
    %ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
    ylabel('Eixo Imaginário','FontSize', 12,'Interpreter','latex')
    %title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
    title('Diagrama de Nyquist de $L(j\omega)$','interpreter','latex')
    %legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
    legend({'Curva de Nyquist','Circulo $\mbox{M}_{\mbox{s}}$'},'interpreter','latex')
    
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