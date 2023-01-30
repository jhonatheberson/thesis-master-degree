function melhor_individuo=gapid(M,D,K,B,d,tau,w,Ms)

warning off
% Popula�ao inicial

populacao_inicial=randi([-1 1],100,3)+rand(100,3);
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

%disp(['Execu��o:  ', num2str(exec+1)])
% Avalia��o

for geracao=1:100
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=randi([-1 1],99,3)+rand(99,3);
    end
    for a=1:size(nova_populacao,1)
%         L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(a,:)')');
        L=Lpid(M,D,K,B,d,tau,w,nova_populacao(a,1:3));
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        %c=crosspid(L,0);
        avaliacao(a,1:end)=[ff c];
        a=a+1;
    end
    
% Fechando a Gera��o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera��o:  ', num2str(geracao)])
% Gerando uma nova popula��o
nova_populacao=ordenacao(nova_populacao);
% disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])

%Fazendo Crossover
%nova_populacao=crossover2(nova_populacao(1:100,1:end-2),B,Lamb);
nova_populacao=crossoverpid(nova_populacao(1:100,1:end-2));
%Verificando se o melhor ind�viduo atende a resposta
% L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(1,:)')');
L=Lpid(M,D,K,B,d,tau,w,nova_populacao(1,1:3));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5))
%c=crosspid(L,0);
if (ff<1e-3 && c<0.9) || (exec>2 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end
geracao=geracao+1;
end
exec=exec+1;
end

%melhor_individuo(2) = 0;
%melhor_individuo(3) = 0;
k=melhor_individuo;
kp = melhor_individuo(1);
ki = melhor_individuo(2);
kd = melhor_individuo(3);
L=Lpid(M,D,K,B,d,tau,w,k(1,1:3));
%L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
plot(real(L),imag(L),':','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=Ms^-1*cos(theta)-1;
y=Ms^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)
plot(-1,0,'rx','LineWidth',1.5)
axis([-3 1 -2 2])
xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
legend boxoff
s=tf('s');
%Hhat=inv(M*s^2+D*s+K+(B*d*(k(3)+(k(2)/s)+(s*k(1)))*exp(-s*tau)));
Hchapeu=inv(M*s^2+D*s+K+B*d*(kp+(ki/s)+(kd*s))*exp(-s*tau));
p=pole(pade(Hchapeu,3));
disp(p)
figure(2)
plot(real(p),imag(p),'x')
hold on
%plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
title('Closed Loop Poles','interpreter','latex')
legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')


IAE = isecomp(k);



disp(['melhor_individuo:  ', num2str(melhor_individuo)])
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])
disp(['IAE:  ', num2str(IAE)])
end