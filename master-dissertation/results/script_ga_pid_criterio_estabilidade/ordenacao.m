function ordenado=ordenacao(x)
b=1;
while b<size(x,1)-1
    for i=1:size(x,1)-1
        if x(i,size(x,2))>x(i+1,size(x,2))
            a=x(i,:);
            x(i,:)=x(i+1,:);
            x(i+1,:)=a;
            b=1;
        else
            b=b+1;
        end
        i=i+1;
    end
end

b=1;
while b<size(x,1)-1
    for i=1:size(x,1)-1
        if x(i,size(x,2)-1)>x(i+1,size(x,2)-1)&&x(i,size(x,2))<0.9&&x(i+1,size(x,2))<0.9
            a=x(i,:);
            x(i,:)=x(i+1,:);
            x(i+1,:)=a;
            b=1;
        else
            b=b+1;
        end
        i=i+1;
    end
end
ordenado=x;