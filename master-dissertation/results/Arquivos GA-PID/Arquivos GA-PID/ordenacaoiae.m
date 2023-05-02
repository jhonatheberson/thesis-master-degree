function ordenado=ordenacaoiae(x)
b=1;
while b<size(x,1)-1
    for i=1:size(x,1)-1
        if x(i,6)>x(i+1,6)
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
        if x(i,5)>x(i+1,5)&& x(i,6)==0 && x(i+1,6)==0
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
        if x(i,4)>x(i+1,4) && x(i,6)==0 && x(i+1,6)==0 && x(i,5)<1e-3 && x(i+1,5)<1e-3
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