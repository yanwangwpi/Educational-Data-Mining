function [metric_train, metric_test]=get_rsquare(itrain,itest,data_train,data_test)
% One predictor

testnum = sum(itest);
trainnum = sum(itrain);

if sum(itrain)~=0
    [b,dev1,stats] = glmfit(data_train(itrain,1),data_train(itrain,2),'binomial','link','logit');
    pred1 = glmval(b, data_train(itrain,1), 'logit');
    [metric_train.r2, metric_train.rmse,metric_train.r2ef,metric_train.var,metric_train.auc] = rsquare2(data_train(itrain,2),pred1);
    
    predictor = zeros(trainnum,1);
    [b0,dev0,stats] = glmfit(predictor,data_train(itrain,2),'binomial','link','logit');
    metric_train.r2mc = 1-dev1/dev0;
    
    if sum(itest)~=0
        predictor = zeros(sum(itest),1);
        pred2 = glmval(b, data_test(itest,1), 'logit');
        [metric_test.r2, metric_test.rmse,metric_test.r2ef,metric_test.var,metric_test.auc] = rsquare2(data_test(itest,2),pred2);
        dev1 = loglike(b,data_test(itest,1),data_test(itest,2));
        dev0 = loglike(b0,predictor,data_test(itest,2));
        metric_test.r2mc = 1-dev1/dev0;
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
