% This file is used to evaluate the impact of student, and student is
% summarized as percent correctness, percent first item correct, mean
% mastery speed or percent wheel spinning.
function [student_skill_pair,assess_best] =  func_student_covariate(file_name)
%% The "Read in data" and "Preprocess data"  can be replaced if data is already generated
load (file_name);

%% New index
i_skill =1;
i_student = 2;
i_skillc = 3;
i_studentc = 4;
i_skillf = 5;
i_studentf = 6;
i_skillm = 7;
i_studentm = 8;
i_skillw = 9;
i_studentw = 10;
i_oc = 11;
i_maxoc = 12;
i_correct = 13;
i_ms = 14;
i_ws = 15;
% i_studentvlc = 16;
% i_studentvlf = 17;
% i_skillvlc = 18;
% i_skillvlf = 19;

% for data_new_covariate2
i_studentvlc = 16;
i_studentvlf = 16;
i_skillvlc = 16;
i_skillvlf = 16;
i_cross = 16;


crossvl = 10;
for id = 1:crossvl
    metric_tol_train{id}=[];
    metric_tol_test{id} = [];
end

for id = 1:crossvl
testc = data_new(:,i_studentvlc)==id;
trainc = ~testc;

data_new_1 = data_new(data_new(:,i_oc)==1,:);
testf = data_new_1(:,i_studentvlf)==id;
trainf = ~testf;

%% Given student_id, how much can we improve on prediction of  SCORE in each skill, based on correct, first item, mastery speed, wheel spinning
metric_this_train=[];
metric_this_test=[];
index_set = [i_studentc, i_studentf, i_studentm, i_studentw];
for set_id  =1:4
data_train = data_new(trainc,[index_set(set_id),i_correct]);
data_test = data_new(testc,[index_set(set_id),i_correct]);
itrain = data_train(:,1)==data_train(:,1);
itest = data_test(:,1)==data_test(:,1);

[metric_train, metric_test]=get_rsquare(itrain,itest,data_train,data_test);

% if sum(itrain)~=0
% [b,dev,stats] = glmfit(data_train(itrain,1),data_train(itrain,2),'binomial','link','logit');
% pred1 = glmval(b, data_train(itrain,1), 'logit');
% [r2_train rmse] = rsquare2(data_train(itrain,2),pred1);
% if sum(itest)~=0
% pred2 = glmval(b, data_test(itest,1), 'logit');
% [r2_test rmse] = rsquare2(data_test(itest,2),pred2);
% else
%     r2_test=nan;
% end
% else
%     r2_train = nan;
%     r2_test = nan;
% end
metric_this_train =[metric_this_train,metric_train];
metric_this_test =[metric_this_test,metric_test];

end
metric_tol_train{id} =[metric_tol_train{id};metric_this_train];
metric_tol_test{id} =[metric_tol_test{id};metric_this_test];

%% Given student_id, how much can we improve on prediction of FIRST ITEM in each skill, based on correct, first_item, mastery speed, wheel spinning

metric_this_train=[];
metric_this_test=[];
index_set = [i_studentc, i_studentf, i_studentm, i_studentw];
for set_id  =1:4
data_train = data_new_1(trainf,[index_set(set_id),i_correct]);
data_test = data_new_1(testf,[index_set(set_id),i_correct]);
itrain = data_train(:,1)==data_train(:,1);
itest = data_test(:,1)==data_test(:,1);
[metric_train, metric_test]=get_rsquare(itrain,itest,data_train,data_test);
metric_this_train =[metric_this_train,metric_train];
metric_this_test =[metric_this_test,metric_test];

end
metric_tol_train{id} =[metric_tol_train{id};metric_this_train];
metric_tol_test{id} =[metric_tol_test{id};metric_this_test];


%% Given student_id, how much can we improve on prediction of  mastery speed in each skill


metric_this_train=[];
metric_this_test=[];
index_set = [i_studentc, i_studentf, i_studentm, i_studentw];
for set_id  =1:4
data_train = data_new_1(trainf,[index_set(set_id),i_ms]);
data_test = data_new_1(testf,[index_set(set_id),i_ms]);
itrain = data_train(:,1)==data_train(:,1) & data_train(:,2)~=-1;
itest = data_test(:,1)==data_test(:,1)& data_test(:,2)~=-1;
[metric_train, metric_test]=get_rsquare_linear(itrain,itest,data_train,data_test);

metric_this_train =[metric_this_train,metric_train];
metric_this_test =[metric_this_test,metric_test];

end
metric_tol_train{id} =[metric_tol_train{id};metric_this_train];
metric_tol_test{id} =[metric_tol_test{id};metric_this_test];

%% Given student_id, how much can we improve on prediction of  wheel spinning in each skill


metric_this_train=[];
metric_this_test=[];
index_set = [i_studentc, i_studentf, i_studentm, i_studentw];
for set_id  =1:4
data_train = data_new_1(trainf,[index_set(set_id),i_ws]);
data_test = data_new_1(testf,[index_set(set_id),i_ws]);
itrain = data_train(:,1)==data_train(:,1) & data_train(:,2)~=-1;
itest = data_test(:,1)==data_test(:,1)& data_test(:,2)~=-1;
[metric_train, metric_test]=get_rsquare(itrain,itest,data_train,data_test);

metric_this_train =[metric_this_train,metric_train];
metric_this_test =[metric_this_test,metric_test];

end
metric_tol_train{id} =[metric_tol_train{id};metric_this_train];
metric_tol_test{id} =[metric_tol_test{id};metric_this_test];

end

table_train.r2 = zeros(4,4);
table_train.r2mc = zeros(4,4);
table_train.rmse = zeros(4,4);
table_train.r2ef = zeros(4,4);
table_train.var = zeros(4,4);
table_train.auc = zeros(4,4);

table_test.r2 = zeros(4,4);
table_test.r2mc = zeros(4,4);
table_test.rmse = zeros(4,4);
table_test.r2ef = zeros(4,4);
table_test.var = zeros(4,4);
table_test.auc = zeros(4,4);


for id = 1:crossvl
    for irow=1:4
        for icol = 1:4
    table_train.r2(irow,icol) = table_train.r2(irow,icol)+metric_tol_train{id}(irow,icol).r2;
    table_train.r2mc(irow,icol) = table_train.r2mc(irow,icol)+metric_tol_train{id}(irow,icol).r2mc;
    table_train.rmse(irow,icol) = table_train.rmse(irow,icol)+metric_tol_train{id}(irow,icol).rmse;
    table_train.r2ef(irow,icol) = table_train.r2ef(irow,icol)+metric_tol_train{id}(irow,icol).r2ef;
    table_train.var(irow,icol) = table_train.var(irow,icol)+metric_tol_train{id}(irow,icol).var;
    table_train.auc(irow,icol) = table_train.auc(irow,icol)+metric_tol_train{id}(irow,icol).auc;
    
    table_test.r2(irow,icol) = table_test.r2(irow,icol)+metric_tol_test{id}(irow,icol).r2;
    table_test.r2mc(irow,icol) = table_test.r2mc(irow,icol)+metric_tol_test{id}(irow,icol).r2mc;
    table_test.rmse(irow,icol) = table_test.rmse(irow,icol)+metric_tol_test{id}(irow,icol).rmse;
    table_test.r2ef(irow,icol) = table_test.r2ef(irow,icol)+metric_tol_test{id}(irow,icol).r2ef;
    table_test.var(irow,icol) = table_test.var(irow,icol)+metric_tol_test{id}(irow,icol).var;
    table_test.auc(irow,icol) = table_test.auc(irow,icol)+metric_tol_test{id}(irow,icol).auc;
        end
    end
end
    table_train.r2 = table_train.r2/crossvl;
    table_train.r2mc = table_train.r2mc/crossvl;
    table_train.rmse = table_train.rmse/crossvl;
    table_train.r2ef = table_train.r2ef/crossvl;
    table_train.var = table_train.var/crossvl;
    table_train.auc = table_train.auc/crossvl;
    
    table_test.r2 = table_test.r2/crossvl;
    table_test.r2mc = table_test.r2mc/crossvl;
    table_test.rmse = table_test.rmse/crossvl;
    table_test.r2ef = table_test.r2ef/crossvl;
    table_test.var = table_test.var/crossvl;
    table_test.auc = table_test.auc/crossvl;


student_skill_pair=[length(unique(data_new_1(:,i_student))),length(unique(data_new_1(:,i_skill))),size(data_new_1,1),size(data_new,1)];

    
assess_best = [table_test.r2(1,1),table_test.r2mc(1,1),table_test.r2ef(1,1),table_test.rmse(1,1),table_test.auc(1,1),table_test.var(1,1),nanmean(data_new(:,i_correct)),table_test.rmse(1,1)^2/(1-table_test.r2ef(1,1)),... %nanstd(data_new(:,i_studentc)),
    table_test.r2(2,2),table_test.r2mc(2,2),table_test.r2ef(2,2),table_test.rmse(2,2),table_test.auc(2,2),table_test.var(2,2),nanmean(data_new_1(:,i_correct)),table_test.rmse(2,2)^2/(1-table_test.r2ef(2,2)),...%nanstd(data_new_1(:,i_studentf)),
    table_test.r2(3,3),table_test.r2ef(3,3),table_test.rmse(3,3),table_test.var(3,3),nanmean(data_new_1(data_new_1(:,i_ms)~=-1,i_ms)),table_test.rmse(3,3)^2/(1-table_test.r2ef(3,3)),...%nanstd(data_new_1(:,i_studentm)),
    table_test.r2(4,4),table_test.r2mc(4,4),table_test.r2ef(4,4),table_test.rmse(4,4),table_test.auc(4,4),nanmean(data_new_1(data_new_1(:,i_ws)~=-1,i_ws)),table_test.var(4,4),table_test.rmse(4,4)^2/(1-table_test.r2ef(4,4))];%nanstd(data_new_1(:,i_studentw)),