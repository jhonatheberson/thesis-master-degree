function nova_geracao=crossover2(populacao_atual)

% |Selecionando os pais|
pais=populacao_atual(1,:);
for i=1:size(populacao_atual,1)
   if rand<(0.7-i*1e-2)
     %populacao_atual(i,size(populacao_atual,2));
      pais(size(pais,1)+1,:)=populacao_atual(i,:);
   end
    i=i+1;
end

nova_geracao=pais(:,:);

%|Realizar os cruzamentos|
for i=1:size(pais,1)-1
    for j=2:size(pais,1)
        if randi(2*size(pais,1)-1,1)>i+j
           nova_geracao=[nova_geracao; pais(i,:)+rand*(pais(i,:)-pais(j,:))];
           if rand<0.11
                mut=randi(size(nova_geracao,2),1);
                nova_geracao(end,mut:end)=rand(1,size(nova_geracao,2)-mut+1);
            end
        end
        j=j+1;
    end
    i=i+1;  
end
if size(nova_geracao,1)<100
    nova_geracao(size(nova_geracao,1)+1:100,:)=5*rand(100-size(nova_geracao,1)+1, 3);
end