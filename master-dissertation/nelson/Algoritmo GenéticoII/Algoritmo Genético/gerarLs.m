function Ls=gerarLs(HB,tauf,taug,w,x,B)
%Gera��o de Ljw ponto a ponto
%x � o indiv�duo
for a=1:length(w)
    Ls(a)=-(x(:,size(B,1)+1:end)*exp(-(j*w(a))*taug)+(j*w(a))*x(:,1:size(B,1))*exp(-(j*w(a))*tauf))*HB(:,a);
    a=a+1;
end

end