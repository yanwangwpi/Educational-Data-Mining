function [d, s] = cohend(x1,x2)
index = x1==x1;
x1 = x1(index);
index = x2==x2;
x2 = x2(index);

n1 = length(x1);
n2 = length(x2);
s12 = var(x1);
s22 = var(x2);
s = (((n1-1)*s12+(n2-1)*s22)/(n1+n2-2))^0.5;
d = (mean(x1)-mean(x2))/s;
