% This file is used to read in ASSISTMENTs data, and build logistical regression
% model for mastery speed

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

data = csvread('merged part4&5 - use the entire data set''s coefficients.csv', 2,0);

data = data(:,1:30);

speedlimit =11;

index = data(:,i_ws)==1 & data(:,i_speed)>speedlimit;
dataw = data(index,:);
datam = data(~index,:);

datanew=[];
skills = unique(dataw(:,i_skill));
for id1 = 1:length(skills)
    index = dataw(:,i_skill) == skills(id1);
    dataskill = dataw(index,:);
    users = unique(dataskill(:,i_user));
    for id2 = 1:length(users)
        index = dataskill(:,i_user)==users(id2);
        datauser = dataskill(index,:);
        numprac = max(datauser(:,i_numprac));
        mspeed = datauser(1,i_speed);
        if mspeed==999
            datauser(:,i_speed)= speedlimit;%min([numprac+5+1,]);
        else
            if mspeed>speedlimit
                datauser(:,i_speed)=speedlimit;
            end
        end
        datanew=[datanew;datauser];
    end
end

data = [datam;datanew];

index = data(:,i_numprac)<10 & data(:,i_numprac)>=3;
data = data(index,:);
%% order data
data = sortrows(data, [i_skill,i_user,i_order]);

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
prediction = zeros(size(datad,1),1);

for id = 1
    test = datad(:,i_group)==id;
    train = ~test;
    traindata = datad(train,:);
    testdata = datad(test,:);
    
    [b,dev,stats] = glmfit(traindata(:,[6:18,31:end]),traindata(:,i_ws),'binomial','link','logit');
    yfit = glmval(b, testdata(:,[6:18,31:end]), 'logit');
    prediction(test) = yfit;
end

actual = datad(:,i_ws);
[X,Y,T,AUC] = perfcurve (actual, prediction);

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



