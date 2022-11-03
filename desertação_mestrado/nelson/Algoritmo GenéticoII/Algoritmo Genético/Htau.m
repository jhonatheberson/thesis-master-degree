function ff=Htau(NUM,DEN,s,B,tauf,taug,w,Ms,x)

% M é a matriz de massas nxn
% D é a matriz de amortecimento nxn
% K é a matriz de elasticidade nxn
% B é a matriz de entradas nxm
% x é o vetor de ganhos f, g 1xn


%Ls = (x(1:length(B))*exp(-tauf*s)*s+x(length(B)+1:2*length(B))*exp(-taug*s))*(NUM)/DEN(1);
Ls = (x(1:length(B))*exp(-tauf*s)*s+x(length(B)+1:2*length(B))*exp(-taug*s))*(NUM)/DEN(1);

% k=k0+V*x';
% f=k(1:length(B));
% g=k(length(B)+1:2*length(B));
% Ls = (f'*exp(-tauf*s)*s+g'*exp(-taug*s))*(NUM)/DEN(1);


[Re Im]=nyquist(Ls,w);
dist=sqrt((Re+1).^2+Im.^2);

% cross=[Re(1)];
% 
% for i=1:length(Im)-1
%         if Im(i)*Im(i+1)<0
%         cross=[cross (Re(i)+Re(i+1))/2];
%         end
%         i=i+1;
% end

% ff=(min(cross)+Ms^-1)^2+(min(dist) - Ms^-1)^2;
  ff=(min(dist)-Ms^-1)^2;  
end