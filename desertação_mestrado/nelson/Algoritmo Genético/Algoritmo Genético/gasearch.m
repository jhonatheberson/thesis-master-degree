function melhor_individuo=gasearch(M,D,K,B,tauf,taug,w,Lamb,Ms,T)

warning off
%Gera??o das Matrizes G, h, k0 e V
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

% Popula?ao inicial

populacao_inicial=[rand+randi([-1e3,1e3],40,2*length(B)-length(Lamb));rand+randi([-1e2,1e2],30,2*length(B)-length(Lamb));rand+randi([-10,10],30,2*length(B)-length(Lamb))];;
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

disp(['Execu??o:  ', num2str(exec+1)])
% Avalia??o

for geracao=1:100
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=[rand+randi([-1e3,1e3],33,2*length(B)-length(Lamb));rand+randi([-1e2,1e2],33,2*length(B)-length(Lamb));rand+randi([-10,10],33,2*length(B)-length(Lamb))];
    end
    for a=1:size(nova_populacao,1)
        L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(a,:)')');
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        avaliacao(a,1:end)=[ff c];
        a=a+1;
    end
    
% Fechando a Gera??o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera??o:  ', num2str(geracao)])
% Gerando uma nova popula??o
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avalia??o:  ', num2str(avaliacao(1,:))])
%Fazendo Crossover
nova_populacao=crossover2(nova_populacao(1:100,1:end-2),B);
%Verificando se o melhor ind?viduo atende a resposta
L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(1,:)')');
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
if (ff<1e-12 && c<0.9) || (exec>5 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end
geracao=geracao+1;
end
exec=exec+1;
end


k=(k0+V*melhor_individuo')';
L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
plot(real(L),imag(L),':','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=Ms^-1*cos(theta)-1;
y=Ms^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)
plot(-1,0,'rx','LineWidth',1.5)
xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
legend boxoff
s=tf('s');
Hhat=inv(M*s^2+(D-B*k(1:length(B))*exp(-s*tauf))*s+(K-B*k(length(B)+1:end)*exp(-s*taug)));
p=pole(pade(Hhat,3));
figure(2)
plot(real(p),imag(p),'x')
hold on
plot(real(Lamb),imag(Lamb),'o','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
title('Closed Loop Poles','interpreter','latex')
legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')
end