s=tf('s');

% k1=(k0+V*melhor_individuo_ms1333')';
% f1=k1(1:length(B));
% g1=k1(length(B)+1:2*length(B));
% 
% k2=(k0+V*melhor_individuo')';
% f2=k2(1:length(B));
% g2=k2(length(B)+1:2*length(B));
% 
% k3=(k0+V*melhor_individuo_ms2')';
% f3=k3(1:length(B));
% g3=k3(length(B)+1:2*length(B));

Hhat1=inv(M*s^2+(D-B*f*exp(-s*tauf))*s+(K-B*g*exp(-s*taug)));
p1=pole(pade(Hhat1,3));
Hhat2=inv(M*s^2+(D-B*F'*exp(-s*tauf))*s+(K-B*G'*exp(-s*taug)));
p2=pole(pade(Hhat2,3));
% Hhat3=inv(M*s^2+(D-B*f3*exp(-s*tauf))*s+(K-B*g3*exp(-s*taug)));
% p3=pole(pade(Hhat3,3));

plot(real(p1),imag(p1),'x','Linewidth',1,'MarkerSize',6)
hold on
plot(real(p2),imag(p2),'s','color',[0.5 0.5 0],'MarkerSize',8,'Linewidth',1)
% plot(real(p3),imag(p3),'g^','MarkerSize',8)%,'Linewidth',1)
plot(real(Lamb),imag(Lamb),'ro','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
title('Closed Loop Poles','interpreter','latex')
legend({'CLP Prop. Method','CLP Ref. Example','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')

% axis([-1 0 -0.5 0.5])
