function [melhor_individuo, IAE]=gasearch(M,C,K,b,d,tau,w,Ms)

warning off
variable=1;
%Gera��o das Matrizes G, h, k0 e V
% for a=1:length(Lamb);
% G(a,1:2*length(B))=[Lamb(a)*exp(-tauf*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).' exp(-taug*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).'];
% h(a)=1;
% a=a+1;
% end
% 
% %Etapa de Verifica��o, se os autovalores s�o reais ou complexos;
% if max(imag(Lamb))~=0
% k0=(T*G)\(T*h.');
% V=null(T*G);
% else
% k0=(G)\(h.');
% V=null(G);    
% end
evalution = [];
sizepopulation = 100;
populacao_inicial = 10*rand(100, 3);
%options = psoptimset('MaxFunEvals',4000);
% Popula�ao inicial

% for a=1:length(sizepopulation)
%     populacao_inicial(0:100)=[randi([0,20]) randi([0,20]) randi([0,20])];
%     a=a+1;
% end

%populacao_inicial(0, 100)= [randi([0,20]) randi([0,20]) randi([0,20])];

nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

disp(['Execu��o:  ', num2str(exec+1)])
% Avalia��o

for geracao=1:100
    avaliacao=[0 0 0];
    if exec>0
        disp(['Execucao:  ', num2str(exec)])
        nova_populacao=10*rand(100, 3);
    end
    for a=1:size(nova_populacao,1)
        %L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(a,:)')');
        L=L_ponto_a_ponto(M,C,K,b,d,tau,w,nova_populacao(a,:));
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        IAE = isecomp(nova_populacao(a,:));
        avaliacao(a,1:end)=[ff IAE c];
        a=a+1;
    end
    
% Fechando a Gera��o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera��o:  ', num2str(geracao)])
% Gerando uma nova popula��o
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])
%Fazendo Crossover
nova_populacao=crossover2(nova_populacao(1:100,1:end-3));
%Verificando se o melhor ind�viduo atende a resposta
%x0 = (k0+V*nova_populacao(1,:)')';
x0 = nova_populacao(1,:);
L=L_ponto_a_ponto(M,C,K,b,d,tau,w,nova_populacao(1,:));
%L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,nova_populacao(1,:));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
IAE = isecomp(x0);
disp(['IAE:  ', num2str(IAE)])
%[x,IAE,~,output] = patternsearch(@(x)isecomp(x),x0,[],[],[],[],[0;0;0],[10;10;10],@(x,M,C,K,b,d,tau,w,Ms)creterian(x,M,C,K,b,d,tau,w,Ms),options);%,@(x)horu(x));%,options);
if (ff<0.6 && c<0.9 && IAE<0.9) || (exec>2 && c<0.9)
%if (ff<0.00001 && c<0.9) || (exec>2 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end


%avali��o de variabilidade genetica
evalution(variable) = IAE;
variable = variable + 1;
if(length(evalution) > 10)
    variable = 1;
    evalution = evalution(2:end);
    if (var(evalution) < 0.0000001)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
    end
end


geracao=geracao+1;
end
exec=exec+1;
end


k=melhor_individuo;
kp = k(1);
ki = k(2);
kd = k(3);
L=L_ponto_a_ponto(M,C,K,b,d,tau,w,k);
%L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
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
ylabel('Eixo Imagin�rio','FontSize', 12,'Interpreter','latex')
%title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
title('Diagrama de Nyquist de $L(j\omega)$','interpreter','latex')
%legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
legend({'Curva de Nyquist','Circulo $\mbox{M}_{\mbox{s}}$'},'interpreter','latex')
legend boxoff
s=tf('s');
Hhat=inv(M*s^2+C*s+K+(b*d*(k(3)+(k(2)/s)+(s*k(1)))*exp(-s*tau)));
p=pole(pade(Hhat,3));
figure(2)
plot(real(p),imag(p),'x')
hold on
%plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
%title('Closed Loop Poles','interpreter','latex')
title('Polos de malha fechada','interpreter','latex')
%legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')
legend({'Polos de malha fechada','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')

figure(3)
%plot simula��o
plot(tempo,estados_x(:,1),'--','linewidth',2.0)
xlabel('$Tempo (s)$','FontSize', 10,'Interpreter','latex')
ylabel('$Sinal$','FontSize', 10,'Interpreter','latex')
hold on
%grid on
plot(tempo,estados_x(:,2),'-','linewidth',2.0)
legend('Refer�ncia','Sinal')
title('simula��o do sistema')

IAE = isecomp(k);
disp(['melhor_individuo:  ', num2str(melhor_individuo)])
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])
disp(['IAE:  ', num2str(IAE)])
end



function f = isecomp(x)

%plot(x(1),x(2),'ok');
%secorderpid2nd
set_param('secorderpid2nd/Proportional','Gain',num2str(x(1)))
set_param('secorderpid2nd/Integral','Gain',num2str(x(2)))
set_param('secorderpid2nd/Derivative','Gain',num2str(x(3)))
sim('secorderpid2nd.slx');

f = IAE(length(IAE))

end