simulink = 'SimulacaoPID';
%simulink = 'secorderpid2nd_add_filters';

melhor_individuo=gapid(M,D,K,B,d,tau,w,Ms,simulink);
plots(melhor_individuo,M,D,K,B,d,tau,w,Ms,simulink);
kp = melhor_individuo(1);
ki = melhor_individuo(2);
kd = melhor_individuo(3);