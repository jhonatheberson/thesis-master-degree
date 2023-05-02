function melhor_individuo=gapid(M,D,K,B,d,tau,w,Ms,Z)

warning off
% Populaçao inicial

populacao_inicial=randi([-1 1],100,3)+rand(100,3);
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

%disp(['Execução:  ', num2str(exec+1)])
% Avaliação

for geracao=1:100
    avaliacao=[0 0 0];
    if exec>0
        nova_populacao(2:100,:)=randi([-1 1],99,3)+rand(99,3);
    end
    for a=1:size(nova_populacao,1)
        L=Lpid(M,D,K,B,d,tau,w,nova_populacao(a,1:3));
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        kp=nova_populacao(a,1);ki=nova_populacao(a,2);kd=nova_populacao(a,3);
        SimOut=sim('SimulacaoPID','ReturnWorkspaceOutputs', 'on');
        int=SimOut.get('iae');
        c=crosspid(L,Z);
        avaliacao(a,1:end)=[int(end) ff c];
        a=a+1;
    end
    
% Fechando a Geração
nova_populacao=[nova_populacao avaliacao];
disp(['Geração:  ', num2str(geracao)])
% Gerando uma nova população
nova_populacao=ordenacaoiae(nova_populacao);
disp(['Melhor Avaliação:  ', num2str(avaliacao(1,:))])

%Fazendo Crossover
%nova_populacao=crossover2(nova_populacao(1:100,1:end-2),B,Lamb);
nova_populacao=crossoverpid(nova_populacao(1:100,1:end-3));
%Verificando se o melhor indíviduo atende a resposta
% L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,(k0+V*nova_populacao(1,:)')');
L=Lpid(M,D,K,B,d,tau,w,nova_populacao(1,1:3));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
% c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5))
c=crosspid(L,Z);
if (ff<1e-3 && c==0) && geracao>2
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end
geracao=geracao+1;
end
exec=exec+1;
end

L=Lpid(M,D,K,B,d,tau,w,melhor_individuo);
% k=(k0+V*melhor_individuo')';
% L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
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
end