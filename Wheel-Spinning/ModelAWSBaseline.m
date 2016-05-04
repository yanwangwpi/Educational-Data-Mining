% This file is used to read in ASSISTMENTs data, and build logistical regression
% model for WS

clc;
clear all;
close all;

% 1.problem_log_id	2.user_id	3.skill_id	4.problem_id	5.correct	 6.prior_s	
% 7.geo_responseTime_zScore	8.correct_in_a_row	
% 9.num_prior_problems_with_any_hint_requests_on_the_skill	10.num_prior_problems_with_more_than_5_hint_requests_on_the_skill	
% 11.num_prior_problems_with_any_hint_requests_in_a_row_across_skills	12.num_prior_problems_with_more_than_5_hint_requests_in_a_row_across_skills	
% 13.counts_fast_incorrect_bin	14.counts_normal_incorrect_bin	15.counts_slow_incorrect_bin	
% 16.counts_fast_correct_bin	17.counts_normal_correct_bin	18.counts_slow_correct_bin	
% 19.num_problems_practced_before	20.ws	21.excessive_problem_after_mastery	22.excessive_problem_after_wheel_spinning	
% 23.num_problem_mastery	 24.num_problem_practiced	25num_attampted_problems	26duration	27hint_count	28group#	
% part_source	valid_duration

% 3.skill and 19. num_problems_practiced_before are nominal variables

i_numprac = 19;
i_ws=20;
i_group = 28;
i_speed = 23;
i_skill =3;
i_user = 2;
i_order = 1;
opp_limit =10;

data = csvread('merged part4&5 - use the entire data set''s coefficients.csv', 2,0);

data = data(:,1:30);

speedlimit =11;

% index = data(:,i_ws)==1 & data(:,i_numprac)<=opp_limit;
% dataw = data(index,:);
% index = data(:,i_ws)==0 & data(:,i_numprac)<=opp_limit;
% datam = data(index,:);

index = data(:,i_numprac)<=opp_limit;
data = data(index,:);

% index = data(:,i_numprac)<10 & data(:,i_numprac)>=3;
% data = data(index,:);
%% order data
prex = dummyvar([data(:,i_skill) data(:,i_numprac)+1]);
% get rid of columns of all zeros
numprex = sum(prex,1);
index = numprex~=0;
prex = prex(:,index);
data = [data,prex];

%% Get the determinant data
% [COEFF, data_predictor] = pca(data(:,[6:18,31:end]));
% data(:,[6:18,31:end])=data_predictor;
index = data(:,i_ws)~=-1;
datad = data(index,:);
datai = data(~index,:);

%% binary prediction
% baseline model
% prediction evaluation (raining, test)(percent correct;AUC;r2)
for id = 1:3
    eval{id} = [];
end


for id = 1:3
    test = datad(:,i_group)==id;
    train = ~test;
    traindata = datad(train,:);
    testdata = datad(test,:);
    
    [b,dev,stats] = glmfit(traindata(:,[6:18,31:end]),traindata(:,i_ws),'binomial','link','logit');
    yfit = glmval(b, traindata(:,[6:18,31:end]), 'logit');
    prediction_train = yfit;
    actual = datad(train,i_ws);
    accnum = sum(actual==(prediction_train>0.5));
    acc = accnum/size(actual,1);
    [X,Y,T,AUC] = perfcurve (actual, prediction_train,1);
    [r2 rmse] = rsquare(actual,prediction_train);   
    eval{id} = [eval{id},[acc;AUC;r2]];
    yfit = glmval(b, testdata(:,[6:18,31:end]), 'logit');
    prediction_test = yfit;
    actual = datad(test,i_ws);
    accnum = sum(actual==(prediction_test>0.5));
    acc = accnum/size(actual,1);
    [X,Y,T,AUC] = perfcurve (actual, prediction_test,1);
    [r2 rmse] = rsquare(actual,prediction_test);
    eval{id} = [eval{id},[acc;AUC;r2]];
end





%% multiple prediction
% prediction2 = zeros(size(datad,1),1);speedlimit;
% for id = 1:3
%     test = datad(:,i_group)==id;
%     train = ~test;
%     traindata = datad(train,:);
%     testdata = datad(test,:);
%     b = regress(traindata(:,i_speed),traindata(:,[6:18,31:end]));
%     yfit3 = testdata(:,[6:18,31:end])*b;
% %     [b,dev,stats] = mnrfit(traindata(:,[6:18,31:end]),traindata(:,i_speed),'model','ordinal');
% %     yfit2 = mnrval(b, testdata(:,[6:18,31:end]),'model', 'ordinal');
%     prediction2(test,:) = yfit3;
% end


% %% binary prediction
% prediction = zeros(size(datad,1),1);
% 
% for id = 1:3
%     test = datad(:,i_group)==id;
%     train = ~test;
%     traindata = datad(train,:);
%     testdata = datad(test,:);
%     
%     [b,dev,stats] = glmfit(traindata(:,[6:18,31:end]),traindata(:,i_ws),'binomial','link','logit');
%     yfit = glmval(b, testdata(:,[6:18,31:end]), 'logit');
%     prediction(test) = yfit;
% end
% 
% 
% %% multiple prediction
% prediction2 = zeros(size(datad,1),1);
% for id = 1:3
%     test = datad(:,i_group)==id;
%     train = ~test;
%     traindata = datad(train,:);
%     testdata = datad(test,:);
%     [b,dev,stats] = mnrfit(traindata(:,[6:18,31:end]),traindata(:,i_speed),'model','ordinal');
%     yfit = mnrval(b, testdata(:,[6:18,31:end]),'link', 'logit');
%     prediction2(test) = yfit;
% end



