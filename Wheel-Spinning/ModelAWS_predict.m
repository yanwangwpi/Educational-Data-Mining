% This file is used to read in ASSISTMENTs data, and build logistical regression
% model for WS, which is used to predict indeterminant cases.

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
opp_limit =5;

data = csvread('merged part4&5 - use the entire data set''s coefficients.csv', 2,0);

data = data(:,1:30);

% % Divide students into new groups
% user = unique(data(:,i_user));
% partition = crossvalind('Kfold',size(user,1),3);
% for id = 1:3
%     indices = ismember(data(:,i_user),user(partition==id));
%     data(indices,i_group) = id;
% end

userskillmaxprac=[];
skills = unique(data(:,i_skill));
for id1 = 1:length(skills)
    index = data(:,i_skill) == skills(id1);
    subdata = data(index,:);
    users = unique(subdata(:,i_user));
    for id2 = 1:length(users)
        index = subdata(:,i_user)==users(id2);
        datauser = subdata(index,:);
        numprac = max(datauser(:,i_numprac));
        mspeed = datauser(1,i_speed);
        userskillmaxprac=[userskillmaxprac;users(id2),skills(id1),numprac];
    end
end

index = data(:,i_numprac)<opp_limit;
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
% WS model
% prediction evaluation (raining, test)(percent correct;AUC;r2)
for id = 1:3
    eval{id} = [];
end

predict_indeter = zeros(size(datad,1),6);

for id = 1

    [b,dev,stats] = glmfit(datad(:,[6:18,31:end]),datad(:,i_ws),'binomial','link','logit');
    yfit = glmval(b, datai(:,[6:18,31:end]), 'logit');
    predict_indeter(:,1) = datai(:,i_user);
    predict_indeter(:,2) = datai(:,i_skill); 
    predict_indeter(:,3) = datai(:,i_numprac);
    predict_indeter(:,5) = id;  
    predict_indeter(:,6) = yfit;
%     predict_indeter(:,7) = actual;
    
end

for id = 1:size(predict_actual,1)
    index_max = userskillmaxprac(:,1)==predict_actual(id,i_user) & userskillmaxprac(:,2)==predict_actual(id,i_skill);
    predict_indeter(id,4) = userskillmaxprac(index_max,3);
end

% statistics

load predict_actual5_deter;

% trim prediction results to max opp
% index = (predict_actual5_deter(:,3)==predict_actual5_deter(:,4)) | (predict_actual5_deter(:,3)==opp_limit-1);
% predict_actual_trimmed = predict_actual5_deter(index,:);
% index = predict_actual_trimmed(:,4)>=10;
% predict_actual_trimmed(index,4)=9;
% index = (predict_indeter(:,3)==predict_indeter(:,4)) | (predict_indeter(:,3)==opp_limit-1);
% predict_indeter_trimmed = predict_indeter(index,:);
% index = predict_indeter_trimmed(:,4)>=10;
% predict_indeter_trimmed(index,4)=9;
nummaster_tol=[];
numws_tol=[];
for opp = 0:opp_limit-1
    index = predict_actual5_deter(:,4)==opp;
    nummaster = sum(predict_indeter_trimmed(index,6)<0.5);
    numws = sum(predict_indeter_trimmed(index,6)>=0.5);
    nummaster_tol = [nummaster_tol,nummaster];
    numws_tol = [numws_tol,numws];
end

precision=[];
recall=[];
for opp=0:opp_limit-1
    index = predict_actual_trimmed(:,4)==opp;
    prec = sum(predict_actual_trimmed(index,6)>=0.5 & predict_actual_trimmed(index,7)==1)/...
        sum(predict_actual_trimmed(index,6)>=0.5);
    precision = [precision,prec];
    
    rec = sum(predict_actual_trimmed(index,6)>=0.5 & predict_actual_trimmed(index,7)==1)/...
        sum(predict_actual_trimmed(index,7)==1);
    recall = [recall,rec];
end




