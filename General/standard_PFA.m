
% data of one skill
% load PFA_data;
clc;
clear all;
close all;
% Necessary data for PFA is copied to a new sheet to save time for loading
% file
% PFA_data =[order_initial, order_id,student_id,skill_ids,Correct];
% order_initialis the order in original file. After processing data, we can
% order by order initials, and copy the result back to the original file.

% order id, train_test_set, assignment_id, student_id, skill_seq, correct
% train_test_set, train =1, test=0
% PFA_data = csvread('PFAdata.csv',2,0);


%% process data, mainly for skill_id
[data,txt,raw] = xlsread('PFAdata.xlsx','PFAdata');
raw = raw(2:end,:);
dataLen = size(raw,1);
skill_seq = 5;
% the skill_id is weird, we need to deal with them specifically
ending = 457730-2;

skill_id_cur = data(ending, skill_seq)+1;
raw_part = raw(ending+1:end,:);

opp2 = [];
initl = cell2mat(raw_part(1,skill_seq));
count = 0;
i = 1;
len_raw_part = length(raw_part);
while (i<=len_raw_part)
    cur = cell2mat(raw(i,skill_seq));
    if size(initl,2)~=size(cur,2) | ~all(initl==cur,2)
       initl = cur;
       skill_id_cur = skill_id_cur+1;
       data(i+ending,skill_seq) = skill_id_cur;
    else
        data(i+ending,skill_seq) = skill_id_cur;
    end 
    i = i+1;
end



%% PFA 
i_order =2;
i_user = 5;
i_correct = 7;
i_skill = 6;
i_test = 3;
i_orignal_order=1;
PFA_data = data;
PFA_data = [(1:size(PFA_data,1))',PFA_data];
PFA_data = sortrows(PFA_data,[i_skill,i_user,i_order]);

% calculate history of each student in each skill
skills = unique(PFA_data(:,i_skill));
historyAll=[];
NPC = [];
for id_skill = 1:length(skills)
    index = PFA_data(:,i_skill)==skills(id_skill);
    data = PFA_data(index,:);
    students = unique(data(:,i_user));
    historySuc = zeros(length(data),2);
    
    for id_stu = 1: length(students)
        index = find(data(:,i_user)==students(id_stu));
        indexLength = length(index);
        historySuc(index(1),1) = data(index(1),i_correct);
        historySuc(index(1),2) =1;
        npc = data(index,i_correct);
        npc = [npc(2:end);nan];
        for i = 2:indexLength
            historySuc(index(i),1) = historySuc(index(i-1),1)+data(index(i),i_correct);
            historySuc(index(i),2) = historySuc(index(i-1),2)+1;
        end
        NPC = [NPC;npc];
    end
    historyAll = [historyAll;historySuc];
    
end

% index = find(~isnan(NPC));
% NPC = NPC(index);
right = historyAll(:,1);
wrong = historyAll(:,2)-right;
% PFA_data = PFA_data(index,:);

N  = size(NPC,1);
% indices = crossvalind('Kfold', N, 5);

indices = mod(PFA_data(:,i_user),5)+1;

predictionAll = zeros(size(PFA_data,1),2);
rmse =[];

testAll = (indices == i);
trainAll = ~testAll;
residual_tab=[];
%     run PFA in each skill
skills = unique(PFA_data(:,i_skill));
predict_skill=[];
for id = 1:length(skills)
    index = PFA_data(:,i_skill)==skills(id);
    prediction = ones(sum(index),2)*NaN;
    subNPC = NPC(index);
    subright = right(index);
    subwrong = wrong(index);
    
    test = PFA_data(index,i_test)==0;
    train = PFA_data(index,i_test)==1;
    if sum(test)>0 & sum(train)>0
        NPC_train = subNPC(train);
        right_this_train = subright(train);
        wrong_this_train = subwrong(train);
        
        NPC_test = subNPC(test);
        right_this_test = subright(test);
        wrong_this_test = subwrong(test);
        
        % check whether all training sets are NaN
        if length(find(~isnan(NPC_train)))>0
        
        [b,dev,stats] = glmfit([right_this_train,wrong_this_train],[NPC_train,ones(size(NPC_train,1),1)],'binomial','link','logit');
        
        x = b(1)+[right_this_test,wrong_this_test]*b(2:end);
        y =  1 ./ (1 + exp(-x ));
        else
            y = NaN.*ones(size(right_this_test));
        end
        index = find(isnan(NPC_test));
        y(index) = NaN;
        prediction(test,:)=[y, NPC_test];
        predict_skill = [predict_skill;prediction];
        
    else
        predict_skill = [predict_skill;prediction];
    end
end

PFA_data = [PFA_data,predict_skill ];
% PFA_data(trainAll,:) = [PFA_data(trainAll,:), ];
PFA_data = sortrows(PFA_data,[i_orignal_order]);
%     predictionAll(testAll,:) = predict_skill(testAll,:);
%     error{i} = residual_tab;

