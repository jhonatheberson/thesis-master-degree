function [f g]=gasearchoneinv2(HB,tauf,taug,Z,w,Lamb,k0,V,Ms,B)

%HB é a matriz de receptância de malha aberta vezes a matriz de atuadores B
%Z é o número de polos de malha aberta no spd
warning off

% Populaçao inicial

populacao_inicial=[rand+randi([-1,1],50,2*length(B)-length(Lamb));rand+randi([-10,10],50,2*length(B)-length(Lamb))];
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

disp(['Execução:  ', num2str(exec+1)])
% Avaliação

for geracao=1:100
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=[rand+randi([-1e3,1e3],33,2*length(B)-length(Lamb));rand+randi([-1e2,1e2],33,2*length(B)-length(Lamb));rand+randi([-10,10],33,2*length(B)-length(Lamb))];
    end
    for a=1:size(nova_populacao,1)
        Ls=gerarLs(HB,tauf,taug,w,(k0+V*nova_populacao(a,:)')',B);
        ff=(min(sqrt((real(Ls)+1).^2+imag(Ls).^2))-Ms^-1)^2;  
        [c ,~]=crossct(Ls,w);
        avaliacao(a,1:end)=[ff abs(Z-c)];
        a=a+1;
    end
    
% Fechando a Geração
nova_populacao=[nova_populacao avaliacao];
disp(['Geração:  ', num2str(geracao)])
% Gerando uma nova população
nova_populacao=ordenacao(nova_populacao);
%disp(['Melhor Avaliação:  ', num2str(avaliacao(1,:))])
%Fazendo Crossover
nova_populacao=crossover2(nova_populacao(1:100,1:end-2),B,Lamb);
%Verificando se o melhor indíviduo atende a resposta
    Ls=gerarLs(HB,tauf,taug,w,(k0+V*nova_populacao(1,:)')',B);
    ff=(min(sqrt((real(Ls)+1).^2+imag(Ls).^2))-Ms^-1)^2; 
    [c ,~]=crossct(Ls,w);
        if (ff<1e-12 && Z-c==0) || (exec>2 && c==0)
            funcao_objetivo=1;
            melhor_individuo=nova_populacao(1,:);
        break
end
geracao=geracao+1;
end
exec=exec+1;
end


k=(k0+V*melhor_individuo')';
f=k(:,1:size(B,1));
g=k(:,size(B,1)+1:end);
Ls=gerarLs(HB,tauf,taug,w,k,B);
plot(real(Ls),imag(Ls),':','linewidth',1.5)
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