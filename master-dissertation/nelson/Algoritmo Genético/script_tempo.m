for n=1:16
    tic
    melhor_individuo=gasearch(M,D,K,B,tauf,taug,w,Lamb,Ms);
    tempo=toc;
    ga.bestind(n,:)=melhor_individuo;
    ga.timexc(n)=toc;
    disp(['Amostra:  ', num2str(n)])
    n=n+1;
end

% k=(k0+V*ga.bestind(3,:)')';
% L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
% plot(real(L),imag(L),':','linewidth',1.5)
% box off
% theta=0:1e-2:2*pi;
% x=Ms^-1*cos(theta)-1;
% y=Ms^-1*sin(theta);
% hold on
% plot(x,y,'r','LineWidth',1.5)
% plot(-1,0,'rx','LineWidth',1.5)
% xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
% ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
% title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
% legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
% legend boxoff
% s=tf('s');
% Hhat=inv(M*s^2+(D-B*k(1:length(B))*exp(-s*tauf))*s+(K-B*k(length(B)+1:end)*exp(-s*taug)));
% p=pole(pade(Hhat,3));
% figure(2)
% plot(real(p),imag(p),'x')
% hold on
% plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
% xlabel('Re','FontSize', 12,'Interpreter','latex')
% ylabel('Im','FontSize', 12,'Interpreter','latex')
% title('Closed Loop Poles','interpreter','latex')
% legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')
