function u = linConGeneratro(m,a,c,x0,N)

u = zeros(N,1);
x = x0;
for i = 1:N
    x = mod(a*x+c,m);
    u(i) = x/m;
end