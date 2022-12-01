k=(k0+V*melhor_individuo')';
L1=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
L2=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,[F' G']);
plot(real(L1),imag(L1),':','linewidth',1.5)
hold on
plot(real(L2),imag(L2),':','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=Ms^-1*cos(theta)-1;
y=Ms^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)

xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
legend({'Nyquist Curve 1','Nyquist Curve 2','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
plot(-1,0,'rx','LineWidth',1.5)
legend boxoff