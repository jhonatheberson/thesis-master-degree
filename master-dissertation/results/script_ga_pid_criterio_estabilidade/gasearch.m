function melhor_individuo=gasearch(M,C,K,b,d,tau,w,Ms,Lamb)

warning off

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
sizepopulation = 100;
populacao_inicial = 10*rand(100, 3);
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
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=10*rand(100, 3);
    end
    for a=1:size(nova_populacao,1)
        %L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(a,:)')');
        L=L_ponto_a_ponto(M,C,K,b,d,tau,w,nova_populacao(a,:));
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        avaliacao(a,1:end)=[ff c];
        a=a+1;
    end
    
% Fechando a Gera��o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera��o:  ', num2str(geracao)])
% Gerando uma nova popula��o
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])
%Fazendo Crossover
nova_populacao=crossover2(nova_populacao(1:100,1:end-2),b,Lamb);
%Verificando se o melhor ind�viduo atende a resposta
%x0 = (k0+V*nova_populacao(1,:)')';
x0 = nova_populacao(1,:);
L=L_ponto_a_ponto(M,C,K,b,d,tau,w,nova_populacao(1,:));
%L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,nova_populacao(1,:));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
if (ff<1e-12 && c<0.9) || (exec>2 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end
geracao=geracao+1;
end
exec=exec+1;
end


k=melhor_individuo;
L=L_ponto_a_ponto(M,C,K,b,d,tau,w,k);
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
% Hhat=inv(M*s^2+(C-b*k(1:length(b))*exp(-s*tau))*s+(K-b*k(length(b)+1:end)*exp(-s*tau)));
% p=pole(pade(Hhat,3));
% figure(2)
% plot(real(p),imag(p),'x')
% hold on
% plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
% xlabel('Re','FontSize', 12,'Interpreter','latex')
% ylabel('Im','FontSize', 12,'Interpreter','latex')
% title('Closed Loop Poles','interpreter','latex')
% legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')

KP = k(1);
KI = k(2);
KD = k(3);
end