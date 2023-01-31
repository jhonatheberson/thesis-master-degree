function [binario binario_partefracionaria]=binarizando(n)

binario_parteinteira=[];
binario_partefracionaria=[];
parte_inteira=fix(n);
parte_fracionaria=n-parte_inteira;

%parte_inteira=parte_inteira/2;

while parte_inteira>1;
    
    binario_parteinteira=[binario_parteinteira mod(parte_inteira,2)];
       
    parte_inteira=fix(parte_inteira/2);
    
    if parte_inteira==1;
        binario_parteinteira=[binario_parteinteira fix(parte_inteira)];
    end
end

while parte_fracionaria~=0;
   
    parte_fracionaria=parte_fracionaria*2;
    binario_partefracionaria=[binario_partefracionaria fix(parte_fracionaria)];
    parte_fracionaria=parte_fracionaria-fix(parte_fracionaria);
    if parte_fracionaria==0
        binario_partefracionaria=[binario_partefracionaria fix(parte_fracionaria)];
    end
    if length(binario_partefracionaria)>1e2
        break
    end
end

if isempty(binario_parteinteira)
    binario=parte_inteira;
else
for i=1:length(binario_parteinteira)

binario(i)=binario_parteinteira(length(binario_parteinteira)-i+1);
i=i+1;

end
end

if isempty(binario_partefracionaria)
    binario_partefracionaria=0;
else
    if length(binario_partefracionaria)>8
    binario_partefracionaria=binario_partefracionaria(1,1:8);
    end
end
end
