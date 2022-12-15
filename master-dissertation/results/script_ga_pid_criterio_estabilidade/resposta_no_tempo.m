% k1=(k0+V*melhor_individuo_ms1333')';
% f=k1(1:length(B));
% g=k1(length(B)+1:2*length(B));
x= melhor_individuo;
set_param('secorderpid2nd/Proportional','Gain',num2str(x(1)))
set_param('secorderpid2nd/Integral','Gain',num2str(x(2)))
set_param('secorderpid2nd/Derivative','Gain',num2str(x(3)))
sim('secorderpid2nd.slx');
%sim('SFCWTD_sim');

subplot(2,2,1)
plot(tempo,estados_x(:,1),'linewidth',2.0)
xlabel('$t$','FontSize', 10,'Interpreter','latex')
ylabel('$q_1(t)$','FontSize', 10,'Interpreter','latex')
subplot(2,2,2)
plot(tempo,estados_x(:,2),'linewidth',2.0)
xlabel('$t$','FontSize', 10,'Interpreter','latex')
ylabel('$q_2(t)$','FontSize', 10,'Interpreter','latex')
subplot(2,2,3)
plot(tempo,estados_x(:,3),'linewidth',2.0)
xlabel('$t$','FontSize', 10,'Interpreter','latex')
ylabel('$q_3(t)$','FontSize', 10,'Interpreter','latex')
subplot(2,2,4)
plot(tempo,estados_x(:,4),'linewidth',2.0)
xlabel('$t$','FontSize', 10,'Interpreter','latex')
ylabel('$q_4(t)$','FontSize', 10,'Interpreter','latex')

% k2=(k0+V*melhor_individuo')';
% f=k2(1:length(B));
% g=k2(length(B)+1:2*length(B));
f=F';g=G';
sim('SFCWTD_sim')

subplot(2,2,1)
hold on
plot(tempo,estados_x(:,1),'r-.')%,'linewidth',1.0)

subplot(2,2,2)
hold on
plot(tempo,estados_x(:,2),'r-.')%,'linewidth',1.0)

subplot(2,2,3)
hold on
plot(tempo,estados_x(:,3),'r-.')%,'linewidth',1.0)

subplot(2,2,4)
hold on
plot(tempo,estados_x(:,4),'r-.')%,'linewidth',1.0)

% k3=(k0+V*melhor_individuo_ms2')';
% f=k3(1:length(B));
% g=k3(length(B)+1:2*length(B));
% 
% sim('SFCWTD_sim')
% 
% subplot(2,2,1)
% hold on
% plot(tempo,estados_x(:,1),'--','color',[0 0.5 0],'linewidth',1.0)
% 
% subplot(2,2,2)
% hold on
% plot(tempo,estados_x(:,2),'--','color',[0 0.5 0],'linewidth',1.0)
% legend({'$M_s=1.3333$','$M_s=1.6667$','$M_s=2.0000$'},'interpreter','latex','fontsize',8,'Location','best')
% 
% subplot(2,2,3)
% hold on
% plot(tempo,estados_x(:,3),'--','color',[0 0.5 0],'linewidth',1.0)
% 
% subplot(2,2,4)
% hold on
% plot(tempo,estados_x(:,4),'--','color',[0 0.5 0],'linewidth',1.0)