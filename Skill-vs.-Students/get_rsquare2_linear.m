function [metric_train, metric_test]=get_rsquare2_linear(itrain,itest,data_train,data_test)
% Two predictors

testnum = sum(itest);
trainnum = sum(itrain);

metric_test.r2mc = nan;
metric_train.r2mc = nan;

if sum(itrain)~=0
lm = LinearModel.fit(data_train(itrain,1:2),data_train(itrain,3));
pred1 = predict(lm, data_train(itrain,1:2));
[metric_train.r2, metric_train.rmse,metric_train.r2ef,metric_train.var,metric_train.auc] = rsquare2(data_train(itrain,3),pred1);
if sum(itest)~=0
pred2 = predict(lm, data_test(itest,1:2));
[metric_test.r2, metric_test.rmse,metric_test.r2ef,metric_test.var,metric_test.auc] = rsquare2(data_test(itest,3),pred2);
else
        metric_test.r2=nan;
        metric_test.r2mc = nan;
        metric_test.rmse = nan;
        metric_test.r2ef = nan;
        metric_test.var = nan;
        metric_test.auc = nan;
end
else
        metric_test.r2=nan;
        metric_test.r2mc = nan;
        metric_test.rmse = nan;
        metric_test.r2ef = nan;
        metric_test.var = nan;
        metric_test.auc = nan;
        metric_train.r2=nan;
        metric_train.r2mc = nan;
        metric_train.rmse = nan;
        metric_train.r2ef = nan;
        metric_train.var = nan;
        metric_train.auc = nan;
end
