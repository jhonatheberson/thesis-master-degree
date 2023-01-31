simulink = 'secorderpid2nd.slx';

melhor_individuo=gapid(M,C,K,B,d,tau,w,Ms,simulink);
plots(melhor_individuo,M,C,K,B,d,tau,w,Ms,simulink);
kp = melhor_individuo(1);
ki = melhor_individuo(2);
kd = melhor_individuo(3);