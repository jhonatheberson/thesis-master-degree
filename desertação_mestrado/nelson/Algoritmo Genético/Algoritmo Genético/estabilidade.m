function c=estabilidade(x,M,D,K,B,tauf,taug,w)

for a=1:length(w)
L(a)=-(x(length(B)+1:end)*exp(-j*w(a)*taug)+j*w(a)*x(1:length(B))*exp(-j*w(a)*tauf))*inv(M*(j*w(a))^2+D*j*w(a)+K)*B;
a=a+1;
end
cos_theta=(-(real(L)+1)./((real(L)+1).^2+imag(L).^2).^0.5);
c=max(cos_theta);
end
