function melhor_individuo=gapid(M,C,K,B,d,tau,w,Ms,simulink)

warning off

% Populaçao inicial
populacao_inicial=randi([-1 1],100,3)+rand(100,3);
nova_populacao=populacao_inicial;
funcao_objetivo=0;
exec=0;
variable=1;
evalution = [];
while funcao_objetivo==0

disp(['Execução:  ', num2str(exec+1)])

% Avaliação
for geracao=1:100
    avaliacao=[0 0];
    if exec>0
        nova_populacao(2:100,:)=randi([-1 1],99,3)+rand(99,3);
    end
    for a=1:size(nova_populacao,1)
        L=Lpid(M,C,K,B,d,tau,w,nova_populacao(a,1:3));
        ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
        %c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
        c=crosspid(L,0);
        avaliacao(a,1:end)=[ff c];
        a=a+1;
    end
    
% Fechando a Geração
nova_populacao=[nova_populacao avaliacao];
disp(['Geração:  ', num2str(geracao)])
% Gerando uma nova população
nova_populacao=ordenacao(nova_populacao);
disp(['Melhor Avaliação:  ', num2str(avaliacao(1,:))])

% Fazendo Crossover
nova_populacao=crossoverpid(nova_populacao(1:100,1:end-2));
% Verificando se o melhor indíviduo atende a resposta
L=Lpid(M,C,K,B,d,tau,w,nova_populacao(1,1:3));
ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2; 
%c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5))
c=crosspid(L,0);
if (ff<1e-3 && c<0.9) || (exec>2 && c<0.9)
    funcao_objetivo=1;
    melhor_individuo=nova_populacao(1,:);
    break
end


% Avalição de variabilidade genetica
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
disp(['Melhor Avaliação:  ', num2str(avaliacao(1,:))])
disp(['IAE:  ', num2str(IAE)])
end