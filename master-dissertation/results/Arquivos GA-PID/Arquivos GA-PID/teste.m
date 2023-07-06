populacao_inicial=randi([-1 1],100,3)+rand(100,3);
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
while funcao_objetivo==0

%disp(['Execu��o:  ', num2str(exec+1)])
% Avalia��o

for geracao=1:100
    avaliacao=[0 0 0];    
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
    
% Fechando a Gera��o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera��o:  ', num2str(geracao)])
% Gerando uma nova popula��o
nova_populacao=ordenacaoiae(nova_populacao);
disp(['Melhor Indiv�duo:  ', num2str(nova_populacao(1,:))])

%Fazendo Crossover
nova_populacao=crossoverpid(nova_populacao(1:100,1:end-3));
%Verificando se o melhor ind�viduo atende a resposta
L=Lpid(M,D,K,B,d,tau,w,nova_populacao(1,1:3));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
c=crosspid(L,Z);
if (ff<1e-3 && c==0) && geracao>20
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