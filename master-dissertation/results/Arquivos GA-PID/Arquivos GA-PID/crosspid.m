function c=crosspid(Ls,Z)
contadorcw=0;
contadorccw=0;
xcrosses=0;
    %Contagem para w+
    if real(Ls(1))<-1 && abs(imag(Ls(1)))<0.2
        xcrosses=[xcrosses real(Ls(1))];
        if imag(Ls(2))<imag(Ls(1))
            contadorccw=contadorccw+1;
        else
            contadorcw=contadorcw+1;
        end
    end

     for i=1:length(Ls)-1
        
        if imag(Ls(i))*imag(Ls(i+1))<0
            if (real(Ls(i))+real(Ls(i+1)))/2 < -1
                xcrosses=[xcrosses (real(Ls(i))+real(Ls(i+1)))/2];
                if imag(Ls(i+1))<imag(Ls(i)) 
                    contadorccw=contadorccw+1;
                else
                    contadorcw=contadorcw+1;                
                end
             end
        end
        i=i+1;
     end    
% 
%     %Contagem para w-
    for i=1:length(Ls)-1
        if -imag(Ls(length(Ls)-(i-1)))*-imag(Ls(length(Ls)-i))<0
            if(real(Ls(length(Ls)-(i-1)))+real(Ls(length(Ls)-i)))/2 < -1
                xcrosses=[xcrosses (real(Ls(length(Ls)-(i-1)))+real(Ls(length(Ls)-i)))/2];
                if -imag(real(Ls(length(Ls)-(i-1))))>-imag(Ls(length(Ls)-i)) 
                    contadorccw=contadorccw+1;
                else
                    contadorcw=contadorcw+1;                
                end
             end
        end
        i=i+1;
    end
%     min(xcrosses)
%  xcrosses
%  contadorcw
%  contadorccw
  c=(min(xcrosses)*contadorcw+(Z-contadorccw))^2;
end
 