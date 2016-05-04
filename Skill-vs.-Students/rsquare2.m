function [r2 rmse,r2ef,variance,auc] = rsquare2(real,pred)
R = corrcoef(real,pred);
r2 = R(1,2).^2;
rmse = sqrt(mean((real - pred).^2));
r2ef = 1-sum((real-pred).^2)/sum((real-nanmean(real)).^2);
variance = var(real);
if (sum(real==1)+sum(real==0)+sum(real~=real))==size(real,1)
[X,Y,T,auc] = perfcurve(real,pred,1);
else
auc=nan;
end
