function melhor_individuo = meuag(M,D,K,B,tauf,taug,w,Lamb,Ms,T)

warning off
s=tf('s');
H=inv(M*s^2+D*s+K);
[NUM,DEN]=tfdata(H*B);
NUM=tf(NUM,1);
DEN=tf(DEN,1);

% for a=1:length(Lamb);
% G(a,1:2*length(B))=[Lamb(a)*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).' (inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).'];
% h(a)=exp(Lamb(a)*tau);
% a=a+1;
% end
% if max(imag(Lamb))~=0
% k0=(T*G)\(T*h.');
% V=null(T*G);
% else
% k0=(G)\(h.');
% V=null(G);    
% end

for a=1:length(Lamb);
G(a,1:2*length(B))=[Lamb(a)*exp(-tauf*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).' exp(-taug*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).'];
h(a)=1;
a=a+1;
end
if max(imag(Lamb))~=0
k0=(T*G)\(T*h.');
V=null(T*G);
else
k0=(G)\(h.');
V=null(G);    
end

% Populaçao inicial

populacao_inicial=rand+randi([-1e3,1e3],100,2*length(B)-length(Lamb));
nova_populacao=populacao_inicial;
funcao_objetivo=0;
contagem=0;
while funcao_objetivo==0

% Avaliação
restricao_atendida=0;

while restricao_atendida==0
    if contagem>0
       nova_populacao(41:100,:)=rand+randi([-1e3,1e3],60,2*length(B)-length(Lamb));
    end
for restri=1:20
        avaliacao=0; 
for i=1:size(nova_populacao,1)
        c=restricao_cosseno((k0+V*nova_populacao(i,:)')',NUM,DEN,B,s,tauf,taug,w);
        avaliacao(i,:)=c;
        i=i+1;
end

% Fechando a Geração
nova_populacao=[nova_populacao avaliacao];
disp(['Número de Execuções:  ', num2str(contagem+1)])
disp(['Restrição:  ', num2str(restri)])

% Gerando uma nova população
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avaliação:  ', num2str(nova_populacao(1,end))])
if nova_populacao(50,end)<0.95
restricao_atendida=1;
    break
end

% Fazendo Crossover
nova_populacao=crossover(nova_populacao(1:100,:));   
restri=restri+1;
end
contagem=contagem+1;
end

for geracao=1:20
    nova_populacao=nova_populacao(:,1:2*length(B)-length(Lamb));
%     if contagem>0
%         nova_populacao(41:100,:)=rand+randi([-1e3,1e3],60,2*length(B)-length(Lamb));
%     end
    avaliacao=0;
    for i=1:size(nova_populacao,1)
        ff=Htau(NUM,DEN,s,B,tauf,taug,w,Ms,(k0+V*nova_populacao(i,:)')');
        if restricao_cosseno((k0+V*nova_populacao(i,:)')',NUM,DEN,B,s,tauf,taug,w)>0.9
            avaliacao(i,:)=ff^-1;
        else
            avaliacao(i,:)=ff;
        end
        i=i+1;
    end
    
% Fechando a Geração
nova_populacao=[nova_populacao avaliacao];
disp(['Geração:  ', num2str(geracao)])

% Gerando uma nova população
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avaliação:  ', num2str(nova_populacao(1,end))])

% Fazendo Crossover
nova_populacao=crossover_restrito(nova_populacao(1:100,:),NUM,DEN,B,s,Lamb,tauf,taug,w,k0,V);
melhor_individuo=nova_populacao(1,:);
checagem=restricao_cosseno((k0+V*melhor_individuo')',NUM,DEN,B,s,tauf,taug,w);
if (nova_populacao(1,end)<1e-12 && checagem<0.7)
    funcao_objetivo=1;
    break
end
geracao=geracao+1;
end

end
x=(k0+V*melhor_individuo')';
f=x(1:length(B));
g=x(length(B)+1:2*length(B));
Ls =(x(1:length(B))*exp(-tauf*s)*s+x(length(B)+1:2*length(B))*exp(-taug*s))*(NUM)/DEN(1);
%Ls = -(x(1:length(B))*s+x(length(B)+1:2*length(B)))*(NUM)*exp(-tau*s)/DEN(1);
nyquist(Ls)

%Hhat=inv(M*s^2+(D-B*f*exp(-s*tau))*s+(K-B*g*exp(-s*tau)));
Hhat=inv(M*s^2+(D+B*f*exp(-s*tauf))*s+(K+B*g*exp(-s*taug)));
p=pole(pade(Hhat,3));

figure(2)
plot(real(p),imag(p),'x')
hold on
plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
title('Polos de Malha Fechada','interpreter','latex')

% figure(3)
% sim('SFCWTD_sim');
% plot(t,x1,'LineWidth',1.5)
% xlabel('Tempo\ (s)','FontSize', 12,'Interpreter','latex')
% ylabel('$x(t)$','FontSize', 12,'Interpreter','latex')
% title('Resposta Estado $\textbf{x}(t)$ para $M_s=1.6667$','interpreter','latex')
% function z=funcao(x);
% 
% %z=sin(x(1))^7+cos(x(2))*sin(x(2))+x(1)^3;
% z=0.25*x(1).^4+x(2).^2+x(1);
% %nova população







