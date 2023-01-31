function f = isecomp(x,simulink)
    set_param('secorderpid2nd/Proportional','Gain',num2str(x(1)))
    set_param('secorderpid2nd/Integral','Gain',num2str(x(2)))
    set_param('secorderpid2nd/Derivative','Gain',num2str(x(3)))
    sim(simulink);
    f = IAE(length(IAE))
end