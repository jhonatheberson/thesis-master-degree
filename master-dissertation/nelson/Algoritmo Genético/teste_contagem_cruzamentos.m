function [N crosses]=crossct(Ls,w)
contadorcw=0;
contadorccw=0;
ccw=[-1 0];
cw=[-1 0];
    for i=1:length(w)-1
    
        if (real(Ls(i))+1)*(real(Ls(i+1))+1)<0
            if imag(Ls(i))>=0 
                if real(Ls(i+1))-real(Ls(i))>0
                    cw = [cw ;-1 (imag(Ls(i+1))+imag(Ls(i)))/2];
                    contadorcw=contadorcw+1;
                else
                    ccw = [ccw ;-1 (imag(Ls(i+1))+imag(Ls(i)))/2];
                    contadorccw=contadorccw+1;
                end
            else 
                if real(Ls(i+1))-real(Ls(i))>0
                    ccw = [ccw ;-1 (imag(Ls(i+1))+imag(Ls(i)))/2];
                    contadorccw=contadorccw+1;
                else
                    cw = [cw ;-1 (imag(Ls(i+1))+imag(Ls(i)))/2];
                    contadorcw=contadorcw+1;
                end
            end
        end
        i=i+1;
    end
plot(real(Ls),imag(Ls),':','linewidth',1.5)
hold on
plot(ccw(2:end,1),ccw(2:end,2),'ro','linewidth',1.5)
plot(cw(2:end,1),cw(2:end,2),'go','linewidth',1.5)
N=contadorccw-contadorcw
crosses=ccw(2:end,:);
end