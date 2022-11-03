function c=restricao_cosseno(x,NUM,DEN,B,s,tauf,taug,w)

%Ls = -(x(1:length(B))*s+x(length(B)+1:2*length(B)))*(NUM)*exp(-tau*s)/DEN(1);
Ls = (x(1:length(B))*exp(-tauf*s)*s+x(length(B)+1:2*length(B))*exp(-taug*s))*(NUM)/DEN(1);

% k=k0+V*x';
% f=k(1:length(B));
% g=k(length(B)+1:2*length(B));
% Ls = (f'*exp(-tauf*s)*s+g'*exp(-taug*s))*(NUM)/DEN(1);

[Re Im]=nyquist(Ls,w);
cos_theta=(-(Re+1)./((Re+1).^2+Im.^2).^0.5);
c=max(cos_theta);
% ceq=[];
end
