% This file is used to predict half of students' first item performance with the other
% half all items, which is like using normal test score to reflect students'
% initial knowledge. This file includes 5 cross validation

clc;
clear all;
close all;

load correct_table_2013;
load feature_table_2013;

limit_stu = 30;
limit  = 3;
limit_all = limit_stu*limit;

% Correct_table(student_id,sequence_id*limit_stu*limit,problem_id*limit_stu*limit, correct*limit_stu*limit)
% Feature_table(student_id, hint_usage*limit_stu*limit, hint_toal*limit_stu*limit, attempt*limit_stu*limit, time*limit_stu*limit)

i_seq = 2;
i_prob = limit_all+2;
i_correct = limit_all*2+2;
i_hint = 2;
i_hall = limit_all+2;
i_att = limit_all*2+2;
i_time = limit_all*3+2;

% for id = i_time:size(feature_table,2)
%     [time_seq_tmp,index_normal] = get_rid_outlier(feature_table(:,id));
%     feature_table(~index_normal,id)=nan;
% end

num = size(correct_table,1);

base_num = 15;
pred_num = limit_stu-base_num;

K = 5;
N = num;    

r2_binary_general_all=[];
rmse_binary_general_all=[];
coff0_binary_general_all=[];
coff1_binary_general_all=[];

r2_partial_general_all=[];
rmse_partial_general_all=[];
coff0_partial_general_all=[];
coff1_partial_general_all=[];

r2_multi_general_all=[];
rmse_multi_general_all=[];
coff0_multi_general_all=[];
coff1_multi_general_all=[];
coff2_multi_general_all=[];
coff3_multi_general_all=[];
coff4_multi_general_all=[];

for montkalo = 1:100

sample_base = datasample([1:limit_stu],base_num,'Replace',false);
sample_pred = setdiff([1:limit_stu],sample_base);

sample_base_index = [];
for id = 1:1
    sample_base_index = [sample_base_index,(sample_base-1)*3+id-1];
end

sample_pred_index = [];
for id = 1:limit
    sample_pred_index = [sample_pred_index,(sample_pred-1)*3+id-1];
end

base_correct = correct_table(:,i_correct+sample_base_index);
pred_correct = correct_table(:,i_correct+sample_pred_index);
pred_hall = feature_table(:,i_hall+sample_pred_index);
pred_hint = feature_table(:,i_hint+sample_pred_index);
pred_att = feature_table(:,i_att+sample_pred_index);
pred_time = feature_table(:,i_time+sample_pred_index);

pred_partial = partial_credit(pred_correct,pred_hint, pred_hall, pred_att);
% pred_partial = 1-pred_hint./pred_hall-(pred_att-1)*0.3;
index_tmp = pred_partial<0;
pred_partial(index_tmp)=0;
    
base = mean(base_correct,2);

r2_binary = [];
rmse_binary=[];
coff_binary=[];

r2_partial = [];
rmse_partial=[];
coff_partial=[];

r2_multi = [];
rmse_multi=[];
coff_multi=[];


indices = crossvalind('Kfold', N, K);
for id = 1:pred_num
    select = datasample([1:pred_num],id,'Replace',false);
    index = [];
    for id2 = 1:limit
        index = [index,(select-1)*3+id2];
    end
    

    predictor_correct = mean(pred_correct(:,index),2);
    predictor_partial = mean(pred_partial(:,index),2);
    predictor_hint = mean(pred_hint(:,index)./pred_hall(:,index),2);
    predictor_att = mean(pred_att(:,index)-1,2);
    predictor_time = nanmean(pred_time(:,index),2);
    
    
    for fold = 1:K
        test = indices==fold;
        train = ~test;
        
            % Binary
        lm1 = LinearModel.fit(predictor_correct(train), base(train));
        prediction1 = lm1.predict(predictor_correct(test));
        [r2_this rmse_this] = rsquare(base(test),prediction1);
        r2_binary = [r2_binary;lm1.Rsquared.Ordinary,r2_this];
        rmse_binary = [rmse_binary;lm1.RMSE,rmse_this];
        tmp_coff = double(lm1.Coefficients);
        coff_binary = [coff_binary;tmp_coff(:)'];

        %Partial
        lm2 = LinearModel.fit(predictor_partial(train), base(train));
        prediction2 = lm2.predict(predictor_partial(test));
        [r2_this rmse_this] = rsquare(base(test),prediction2);
        r2_partial = [r2_partial;lm2.Rsquared.Ordinary,r2_this];
        rmse_partial = [rmse_partial;lm2.RMSE,rmse_this];
        tmp_coff = double(lm2.Coefficients);
        coff_partial = [coff_partial;tmp_coff(:)'];

%         %Multi feature
%         lm3 = LinearModel.fit([predictor_correct(train),predictor_hint(train),predictor_att(train),predictor_time(train)], base(train));
%         prediction3 = lm3.predict([predictor_correct(test),predictor_hint(test),predictor_att(test),predictor_time(test)]);
%         [r2_this rmse_this] = rsquare(base(test),prediction3);
%         r2_multi = [r2_multi;lm3.Rsquared.Ordinary,r2_this];
%         rmse_multi = [rmse_multi;lm3.RMSE,rmse_this];
%         tmp_coff = double(lm3.Coefficients);
%         coff_multi = [coff_multi;tmp_coff(:)'];
    end
    
end

% Collapse detailed information to general information
r2_binary_general = [];
rmse_binary_general=[];
coff_binary_general=[];

r2_partial_general = [];
rmse_partial_general=[];
coff_partial_general=[];

% r2_multi_general = [];
% rmse_multi_general=[];
% coff_multi_general=[];

for id = 1:pred_num
    r2_binary_general = [r2_binary_general;mean(r2_binary([(id-1)*K+1:id*K],:),1)];
    rmse_binary_general = [rmse_binary_general;mean(rmse_binary([(id-1)*K+1:id*K],:),1)];
    coff_binary_general = [coff_binary_general;mean(coff_binary([(id-1)*K+1:id*K],:),1)];

    r2_partial_general = [r2_partial_general;mean(r2_partial([(id-1)*K+1:id*K],:),1)];
    rmse_partial_general = [rmse_partial_general;mean(rmse_partial([(id-1)*K+1:id*K],:),1)];
    coff_partial_general = [coff_partial_general;mean(coff_partial([(id-1)*K+1:id*K],:),1)];
    
%     r2_multi_general = [r2_multi_general;mean(r2_multi([(id-1)*K+1:id*K],:),1)];
%     rmse_multi_general = [rmse_multi_general;mean(rmse_multi([(id-1)*K+1:id*K],:),1)];
%     coff_multi_general = [coff_multi_general;mean(coff_multi([(id-1)*K+1:id*K],:),1)];
end

r2_binary_general_all=[r2_binary_general_all,r2_binary_general(:,2)];
rmse_binary_general_all=[rmse_binary_general_all,rmse_binary_general(:,2)];
coff0_binary_general_all=[coff0_binary_general_all,coff_binary_general(:,1)];
coff1_binary_general_all=[coff1_binary_general_all,coff_binary_general(:,2)];

r2_partial_general_all=[r2_partial_general_all,r2_partial_general(:,2)];
rmse_partial_general_all=[rmse_partial_general_all,rmse_partial_general(:,2)];
coff0_partial_general_all=[coff0_partial_general_all,coff_partial_general(:,1)];
coff1_partial_general_all=[coff1_partial_general_all,coff_partial_general(:,2)];

% r2_multi_general_all=[r2_multi_general_all,r2_multi_general(:,2)];
% rmse_multi_general_all=[rmse_multi_general_all,rmse_multi_general(:,2)];
% coff0_multi_general_all=[coff0_multi_general_all,coff_multi_general(:,1)];
% coff1_multi_general_all=[coff1_multi_general_all,coff_multi_general(:,2)];
% coff2_multi_general_all=[coff2_multi_general_all,coff_multi_general(:,3)];
% coff3_multi_general_all=[coff3_multi_general_all,coff_multi_general(:,4)];
% coff4_multi_general_all=[coff4_multi_general_all,coff_multi_general(:,5)];
end

figure;
hold on;
plot([1:pred_num],mean(r2_binary_general_all,2));
plot([1:pred_num],mean(r2_partial_general_all,2),'r');
% plot([1:pred_num],mean(r2_multi_general_all,2),'k');
xlabel('# of SBs')
ylabel('R2')
title('R2 of binary/partial/multi feature predictor')
grid on

figure;
hold on;
plot([1:pred_num],mean(rmse_binary_general_all,2));
plot([1:pred_num],mean(rmse_partial_general_all,2),'r');
% plot([1:pred_num],mean(rmse_multi_general_all,2),'k');
xlabel('# of SBs')
ylabel('rmse')
title('rmse of binary/partial/multi feature predictor')
grid on

figure;
plot(coff0_multi_general_all,'.');
xlabel('# of SBs')
ylabel('Intercept')
title('Intercept of multi feature predictors')

figure;
plot(coff1_multi_general_all,'.');
xlabel('# of SBs')
ylabel('Correctness Coefficient')
title('Correctness Coefficient of multi feature predictors')

figure;
plot(coff2_multi_general_all,'.');
xlabel('# of SBs')
ylabel('Hint Coefficient')
title('Hint Coefficient of multi feature predictors')

figure;
plot(coff3_multi_general_all,'.');
xlabel('# of SBs')
ylabel('Attempt-1 Coefficient')
title('Attempt-1 Coefficient of multi feature predictors')

figure;
plot(coff4_multi_general_all,'.');
xlabel('# of SBs')
ylabel('Time Coefficient')
title('Time Coefficient of multi feature predictors')

% figure;
% hold on;
% plot([1:pred_num],mean(rmse_binary_general_all,2));
% plot([1:pred_num],mean(rmse_partial_general_all,2),'r');
% plot([1:pred_num],mean(rmse_multi_general_all,2),'k');
% xlabel('# of SBs')
% ylabel('coefficents')
% title('coefficents of binary/partial/multi feature predictor')