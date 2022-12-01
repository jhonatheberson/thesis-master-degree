warning off

for a=1:length(Lamb);
G(a,1:2*length(B))=[Lamb(a)*exp(-tauf*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).' exp(-taug*Lamb(a))*(inv(M*Lamb(a)^2 + D*Lamb(a) + K)*B).'];
h(a)=1;
a=a+1;
end
if max(imag(Lamb))~=0
k0=(T*G)\(T*h.');
V=null(T*G);
else
k0=(G)\(h.');
V=null(G);    
end

k=(k0+V*melhor_individuo_ms1333')';
L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
subplot(1,3,1)
plot(real(L),imag(L),':','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=1.3333^-1*cos(theta)-1;
y=1.3333^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)
plot(-1,0,'rx','LineWidth',1.5)
xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
%title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
% legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
% legend boxoff
axis([-2 1 -3 3])
s=tf('s');
Hhat=inv(M*s^2+(D-B*k(1:length(B))*exp(-s*tauf))*s+(K-B*k(length(B)+1:end)*exp(-s*taug)));
p=pole(pade(Hhat,3));
figure(2)
subplot(1,3,1)
plot(real(p),imag(p),'x')
hold on
plot(real(Lamb),imag(Lamb),'ro','linewidth',1.5)
xlabel('Re','FontSize', 12,'Interpreter','latex')
ylabel('Im','FontSize', 12,'Interpreter','latex')
%title('Closed Loop Poles','interpreter','latex')
legend({'Closed Loop Poles','Desired Poles'},'interpreter','latex','fontsize',10,'Location','best')

k=(k0+V*melhor_individuo')';
L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
figure(1)
subplot(1,3,2)
plot(real(L),imag(L),':','linewidth',1.5)
hold on
plot(real(Lamb),imag(Lamb),'ro','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=1.6667^-1*cos(theta)-1;
y=1.6667^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)
plot(-1,0,'rx','LineWidth',1.5)
xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
%title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
% legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
% legend boxoff
axis([-2 1 -3 3])
Hhat=inv(M*s^2+(D-B*k(1:length(B))*exp(-s*tauf))*s+(K-B*k(length(B)+1:end)*exp(-s*taug)));
p=pole(pade(Hhat,3));
figure(2)
subplot(1,3,2)
plot(real(p),imag(p),'x')
hold on
plot(real(Lamb),imag(Lamb),'ro','linewidth',1.5)


k=(k0+V*melhor_individuo_ms2')';
L=L_ponto_a_ponto(M,D,K,B,tauf,taug,w,k);
figure(1)
subplot(1,3,3)
plot(real(L),imag(L),':','linewidth',1.5)
box off
theta=0:1e-2:2*pi;
x=2^-1*cos(theta)-1;
y=2^-1*sin(theta);
hold on
plot(x,y,'r','LineWidth',1.5)
plot(-1,0,'rx','LineWidth',1.5)
xlabel('Real Axis','FontSize', 12,'Interpreter','latex')
ylabel('Imaginary Axis','FontSize', 12,'Interpreter','latex')
%title('Nyquist Curve Loop Gain $L(j\omega)$','interpreter','latex')
legend({'Nyquist Curve','$\mbox{M}_{\mbox{s}}$ Circle'},'interpreter','latex')
legend boxoff
axis([-2 1 -3 3])
Hhat=inv(M*s^2+(D-B*k(1:length(B))*exp(-s*tauf))*s+(K-B*k(length(B)+1:end)*exp(-s*taug)));
p=pole(pade(Hhat,3));
figure(2)
subplot(1,3,3)
plot(real(p),imag(p),'x')
hold on
plot(real(Lamb),imag(Lamb),'ro','linewidth',1.5)

figure(3)

k=(k0+V*melhor_individuo_ms1333')';
f=k(1:length(B));
g=k(length(B)+1:2*length(B));
c


k=(k0+V*melhor_individuo')';
f=k(1:length(B));
g=k(length(B)+1:2*length(B));

sim('SFCWTD_sim')

subplot(2,2,1)
hold on
plot(tempo,estados_x(:,1),'r-.')%,'linewidth',1.0)

subplot(2,2,2)
hold on
plot(tempo,estados_x(:,2),'r-.')%,'linewidth',1.0)

subplot(2,2,3)
hold on
plot(tempo,estados_x(:,3),'r-.')%,'linewidth',1.0)

subplot(2,2,4)
hold on
plot(tempo,estados_x(:,4),'r-.')%,'linewidth',1.0)

k=(k0+V*melhor_individuo_ms2')';
f=k(1:length(B));
g=k(length(B)+1:2*length(B));

sim('SFCWTD_sim')

subplot(2,2,1)
hold on
plot(tempo,estados_x(:,1),'--','color',[0 0.5 0],'linewidth',1.0)

subplot(2,2,2)
hold on
plot(tempo,estados_x(:,2),'--','color',[0 0.5 0],'linewidth',1.0)
legend({'$M_s=1.3333$','$M_s=1.6667$','$M_s=2.0000$'},'interpreter','latex','fontsize',8,'Location','best')

subplot(2,2,3)
hold on
plot(tempo,estados_x(:,3),'--','color',[0 0.5 0],'linewidth',1.0)

subplot(2,2,4)
hold on
plot(tempo,estados_x(:,4),'--','color',[0 0.5 0],'linewidth',1.0)
