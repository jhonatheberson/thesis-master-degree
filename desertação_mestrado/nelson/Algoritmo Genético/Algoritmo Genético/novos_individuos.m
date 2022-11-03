function nova_populacao=novos_individuos(populacao_antiga,populacao_inicial)
            
         nova_populacao=crossover(populacao_antiga,populacao_inicial);
         
         for i=1:size(nova_populacao,1)
             if randi(10,1)>8.5
                 nova_populacao(i,:)=randi([-100,100],1)*rand*nova_populacao(i,:);
             end
             i=i+1;
         end
         nova_populacao;

end
