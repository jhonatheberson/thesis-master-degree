%Geração das Matrizes G, h, k0 e V
for a=1:length(Lamb);
G(a,1:2*length(B))=[Lamb(a)*exp(-tauf*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).' exp(-taug*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).'];
h(a)=1;
a=a+1;
end

%Etapa de Verificação, se os autovalores são reais ou complexos;
if max(imag(Lamb))~=0
k0=(T*G)\(T*h.');
V=null(T*G);
else
k0=(G)\(h.');
V=null(G);    
end