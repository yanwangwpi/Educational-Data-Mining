% This file studies whether it is worthwhile to build a different model for
% different opportuniy count

clc;
clear all;
close all;

%% Read file
% order_id	student_id	sequence_id	correct	attempt_count	ms_first_response	hint_count	hint_total	first_action

data = csvread('SkillBuilder2012.csv',1,0);

i_ord = 1;
i_stu=2;
i_skill=3;
i_time = 6;
i_h_count = 7;
i_h_total = 8;
i_correct = 4;

data = sortrows(data,[i_skill,i_stu,i_ord]);

%get sequence with enough data
newdata=[];
unqA=unique(data(:,i_skill));
for id = 1:length(unqA)
    index = data(:,i_skill)==unqA(id);
    if sum(index)>1000
        newdata = [newdata;data(index,:)];
    end
end
data  = newdata;

%change student_id to continous
student_id = unique(data(:,i_stu));
for id = 1:length(student_id)
    index = data(:,i_stu)==student_id(id);
    data(index,i_stu) = id;
end

% change hints number to percentage, and bin to 11 bins[0,0.1,0.2,...,1]
indexHintNon0 = find(data(:,i_h_total)~=0);
hintPercentage = zeros(size(data,1),1);
hintPercentage(indexHintNon0) = data(indexHintNon0,i_h_count)./data(indexHintNon0,i_h_total);
index = find(isnan(hintPercentage));
hintPercentage(index)=0;

data = [data(:,[1,2,3,4,5,6]),hintPercentage,data(:,9)];
i_hint = 7;
i_action = 8;

% process response time
index = find(data(:,i_time)>400000);
data(index,i_time) = NaN;
index = find(data(:,i_time)<0);
data(index,i_time) = NaN;
data(:,i_time) = round(data(:,i_time)/10000);

% Get Next Problem Correctness
% % add opportunity count
skills = unique(data(:,i_skill));
NPC = [];
OPP=[];
for id = 1:length(skills)
    index = data(:,i_skill)==skills(id);
    subdata = data(index,:);
    students = unique(subdata(:,i_stu));
    
    for id2 = 1: length(students)
        index = subdata(:,i_stu)==students(id2);
        npc = subdata(index,i_correct);
        npc = [npc(2:end);nan];
        NPC = [NPC;npc];
        opp = [1:sum(index)]';
        OPP=[OPP;opp];
    end
end
data = [OPP,data];
i_opp = 1;
i_ord = 2;
i_stu=3;
i_skill=4;
i_time = 7;
i_hint = 8;
i_action = 9;
i_correct = 5;
% For RF we need to get rid of data with no NPC
index = find(~isnan(NPC));
data = data(index,:);
NPC = NPC(index);

% put previous info in a row. For opp=2, append info in opp=1; for opp=3,
% append info in opp=1 and 2; ect.
skills = unique(data(:,i_skill));
OPP=[];
PPF=[];
% 9OPP 1order_id	2student_id	3sequence_id	4correct	5attempt_count
% 6ms_first_response	7hint_per 8first_action
for id = 1:length(skills)
    index = data(:,i_skill)==skills(id);
    subdata = data(index,:);
    students = unique(subdata(:,i_stu));
    
    for id2 = 1: length(students)
        index = subdata(:,i_stu)==students(id2);
        %previous problem feature
        if sum(index)==1
            ppf1 = [nan*ones(1,5)];
            ppf2 = [nan*ones(1,5)];
        elseif sum(index)==2
        ppf = subdata(index,5:9);
        ppf1 = [nan*ones(1,5);ppf(1:end-1,:)];
        ppf2 = [nan*ones(2,5)];
        else
        ppf = subdata(index,5:9);
        ppf1 = [nan*ones(1,5);ppf(1:end-1,:)];
        ppf2 = [nan*ones(2,5);ppf(1:end-2,:)];
        end
        PPF = [PPF;[ppf1,ppf2]];
    end
end
data = [data,PPF];
%% Random Forest
% N fold cross validation
N = 5;
% # of tree we build
nTree = 100;
data_origin = data;


% find opp=1
index = data_origin(:,i_opp)==1 | data_origin(:,i_opp)==2 | data_origin(:,i_opp)==3;
data = data_origin(index,:);

% indices = crossvalind('Kfold', dataLen, N);
indices = mod(data(:,i_stu),N)+1;
residual_tab=[];
importance_tab = [];
rmse = [];
r2_tol=[];
for i = 1:N
    test = (indices == i);
    train = ~test;
    
    data_train = data(train,(4:end));
    result_train = NPC(train);
    data_test = data(test,(4:end));
    result_test = NPC(test);
    % 3sequence_id	4correct	5attempt_count
    % 6ms_first_response	7hint_per 8first_action
    indicator = [true,false, false,false,false,true,false, false,false,false,true,false, false,false,false,true];
    err_tol=[];
    
    for NFeature = 2:2:14
        RF = TreeBagger(nTree,data_train,result_train,'method','regression','oobpred','on','oobvarimp','on',...
            'CategoricalPredictors', indicator,'NVarToSample',NFeature );
        tmp =  oobError(RF);
        err_tol=[err_tol,tmp(end)];
    end
    [val,I ] = min(err_tol);
    NF = I*2
    
    RF = TreeBagger(nTree,data_train,result_train,'method','regression','oobpred','on','oobvarimp','on',...
        'CategoricalPredictors', indicator,'NVarToSample',NF );
    result_predict = RF.predict(data_test);
    residual = result_test-result_predict;
%     r2_tol = [r2_tol,rsquared(result_predict,result_test)];
    residual_tab = [residual_tab;residual];
    length(residual)
    rmse = [rmse,(mean(residual.^2))^0.5];
    importance = RF.OOBPermutedVarDeltaError;
    importance_tab = [importance_tab;importance];
end
