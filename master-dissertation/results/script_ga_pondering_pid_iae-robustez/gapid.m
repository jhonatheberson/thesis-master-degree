function melhor_individuo=gapid(M,C,K,B,d,tau,w,Ms,simulink)

warning off

% Popula�ao inicial
populacao_inicial=randi([-1 1],100,3)+rand(100,3);
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
variable=1;
evalution = [];
alfa = 0.5;
while funcao_objetivo==0

disp(['Execu��o:  ', num2str(exec+1)])

% Avalia��o
for geracao=1:100
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=randi([-1 1],99,3)+rand(99,3);
    end
    for a=1:size(nova_populacao,1)
        L=Lpid(M,C,K,B,d,tau,w,nova_populacao(a,1:3));
        robustez=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        %c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        c=crosspid(L,0);
        IAE = isecomp(nova_populacao(a,1:3),simulink);
        %avaliacao(a,1:end)=[ff c];
        ff = fitness(IAE, robustez, alfa);
        avaliacao(a,1:end)=[ff c];
        a=a+1;
    end
    
% Fechando a Gera��o
nova_populacao=[nova_populacao avaliacao];
disp(['Gera��o:  ', num2str(geracao)])
% Gerando uma nova popula��o
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])

% Fazendo Crossover
nova_populacao=crossoverpid(nova_populacao(1:100,1:end-2));
% Verificando se o melhor ind�viduo atende a resposta
L=Lpid(M,C,K,B,d,tau,w,nova_populacao(1,1:3));
robustez=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
%c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5))
c=crosspid(L,0);
IAE = isecomp(nova_populacao(1,:),simulink);
ff = fitness(IAE, robustez, alfa);
%if (c<0.9 && IAE<2.5) || (exec>2 && c<0.9)
if (ff<0.4 && c<0.9) || (exec>2 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end


% Avali��o de variabilidade genetica
evalution(variable) = ff;
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



IAE = isecomp(melhor_individuo,simulink);


disp(['melhor_individuo:  ', num2str(melhor_individuo)])
disp(['Melhor Avalia��o:  ', num2str(avaliacao(1,:))])
disp(['IAE:  ', num2str(IAE)])
disp(['robustez:  ', num2str(robustez)])
end