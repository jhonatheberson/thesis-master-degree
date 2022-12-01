function n=desbinarizar(int,frac)
n=0;
n_frac=0;
for i=1:length(int)
    n=n+int(i)*2^(length(int)-i);
    i=i+1;
end

for i=1:length(frac)
    n_frac=n_frac+frac(i)*2^(-i);
    i=i+1;
end
n=n+n_frac;