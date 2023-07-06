function L=Lpid(M,D,K,B,d,tau,w,x)
%Geração de Ljw ponto a ponto
kp=x(1);
ki=x(2);
kd=x(3);

for a=1:length(w)
    b=j*w(a);
    L(a)=(kp+ki/(b+0.0001)+b*kd)*d*inv(M*b^2+D*b+K)*B*exp(-tau*b);
    %L(a)=-(x(length(B)+1:end)*exp(-1j*w(a)*taug)+1j*w(a)*x(1:length(B))*exp(-1j*w(a)*tauf))*inv(M*(1j*w(a))^2+D*1j*w(a)+K)*B;
        a=a+1;
end
%dist=sqrt((real(L)+1).^2+imag(L).^2); %mínima distância de Ljw para Ms
%cos_theta=(-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5); %ângulo entre o vetor Ljwi e (-1,0)
% ff=(min(sqrt((real(L)+1).^2+imag(L).^2))-Ms^-1)^2;  
% c=max((-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5));
end