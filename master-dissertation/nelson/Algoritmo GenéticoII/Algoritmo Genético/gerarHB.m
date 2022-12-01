for i=1:length(w)
    HB(:,i)=inv(M*(j*w(i))^2+C*(j*w(i))+K)*B(:,1);
    i=i+1;
end
