% Code for paper Influence Of Opportunity Count On The Student Modeling
% Type 2: average of previous 2

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

% calculate history of each student in each skill
students = unique(data(:,i_stu)); 
historySuc = zeros(size(data,1),2);

for idStudent = 1: length(students)
   index = find(data(:,i_stu)==students(idStudent));
   skill = unique(data(index,i_skill));
   for idSkill = 1:length(skill)
        index = find(data(:,i_skill)==skill(idSkill) & data(:,i_stu)==students(idStudent));
        indexLength = length(index);
        historySuc(index(1),1) =0;% data(index(1),i_correct);
        historySuc(index(1),2) =0;%1;
        for i = 2:indexLength
            historySuc(index(i),1) = historySuc(index(i-1),1)+data(index(i-1),i_correct);
            historySuc(index(i),2) = historySuc(index(i-1),2)+1;
        end
   end
end

suc = historySuc(:,1)./historySuc(:,2);
suc = round(suc*5)/5;
index=  suc~=suc;
suc(index)=0;
data = [data,suc];

% change hints number to percentage, and bin to 11 bins[0,0.2,0.4,...,1]
indexHintNon0 = find(data(:,i_h_total)~=0);
hintPercentage = zeros(size(data,1),1);
hintPercentage(indexHintNon0) = data(indexHintNon0,i_h_count)./data(indexHintNon0,i_h_total);
index = find(isnan(hintPercentage));
hintPercentage(index)=0;
hintPercentage = round(hintPercentage*5)/5;

data = [data(:,[1,2,3,4,5,6]),hintPercentage,data(:,9:10)];
i_hint = 7;
i_action = 8;
i_s = 9;

% process response time
index = find(data(:,i_time)>400000);
data(index,i_time) = NaN;
index = find(data(:,i_time)<0);
data(index,i_time) = NaN;
data(:,i_time) = round(data(:,i_time)/20000);

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
i_att=6;
i_time = 7;
i_hint = 8;
i_action = 9;
i_correct = 5;
i_s = 10;
% For RF we need to get rid of data with no NPC
index = find(~isnan(NPC));
data = data(index,:);
NPC = NPC(index);

% average previous 2 info
skills = unique(data(:,i_skill));
OPP=[];
PPF=[];
% i_opp = 1;
% i_ord = 2;
% i_stu=3;
% i_skill=4;
% i_att=6;
% i_time = 7;
% i_hint = 8;
% i_action = 9;
% i_correct = 5;
% i_s = 10;

prev = 2;
% prev 2 includes success percentage, prev 1 and current doesn't
for id = 1:length(skills)
    index = data(:,i_skill)==skills(id);
    subdata = data(index,:);
    students = unique(subdata(:,i_stu));
    
    for id2 = 1: length(students)
        index = subdata(:,i_stu)==students(id2);
        subsub = subdata(index,:);
        eachppf=[];
        subsub(find(subsub(:,i_att)==0),7:9)=nan;
        if sum(index)~=0
        %previous problem feature
        
        ppf = subsub(:,5:10);
        tmpppf=[];
        for num = 1:sum(index)    
            if num==1
                ppf2 = ppf(num,:);
            else 
                if num==2
                    tmp1 = round(nanmean(ppf(1:num,1:4))*5)/5;
                    tmp2 = ppf(num,5);
                    tmp3 = ppf(num-1,6);
                ppf2 = [tmp1,tmp2,tmp3];
                else
                    tmp1 = round(nanmean(ppf(num-2:num,1:4))*5)/5;
                    tmp2 = mode(ppf(num-2:num,5));
                    tmp3 = ppf(num-2,6);
                ppf2 = [tmp1,tmp2,tmp3];
                end
            end
%             ppf2 = round(nanmean(ppf2,1)*10)/10;
            tmpppf =[tmpppf;[ppf2]];
        end
        end
        PPF=[PPF;tmpppf];
    end
end
data = [data(:,1:4),PPF];
%% Random Forest
% N fold cross validation
N = 5;
% # of tree we build
nTree = 100;
data_origin = data;

rmse = [];
importance_tol=[];
% find opp=1
for i = 1:N
residual_all{i}=[];
end

for oppor = 1:15
index = data_origin(:,i_opp)==oppor;% | data_origin(:,i_opp)==2 | data_origin(:,i_opp)==3;
data = data_origin(index,:);

% indices = crossvalind('Kfold', dataLen, N);
indices = mod(data(:,i_stu),N)+1;
residual_tab=[];
importance_tab = [];

r2_tol=[];
for i = 1:N
    test = (indices == i);
    train = ~test;
    
    data_train = data(train,4:end);
    result_train = NPC(train);
    data_test = data(test,4:end);
    result_test = NPC(test);
% i_opp = 1;
% i_ord = 2;
% i_stu=3;
% i_skill=4;
% i_att=6;
% i_time = 7;
% i_hint = 8;
% i_action = 9;
% i_correct = 5;
% i_s = 10;
% 4,5-10,5-9,5-9
    indicator = [true, false, false,false,false,true,false];
    
%     skills = unique(data_train(:,1));
%     residual_skill=[];
%     for id_skill = 1:length(skills)
%         index_skill = data_train(:,1)==skills(id_skill);
        err_tol=[];
    for NFeature = 2:2:6
        RF = TreeBagger(nTree,data_train,result_train,'method','regression','oobpred','on','oobvarimp','on',...
            'CategoricalPredictors', indicator,'NVarToSample',NFeature );
        tmp =  oobError(RF);
        err_tol=[err_tol,tmp(end)];
    end
    [val,I ] = min(err_tol);
    NF = I*2
%     NF = 2;
    RF = TreeBagger(nTree,data_train,result_train,'method','regression','oobpred','on','oobvarimp','on',...
        'CategoricalPredictors', indicator ,'NVarToSample',NFeature);
    importance = RF.OOBPermutedVarDeltaError;
    importance_tab = [importance_tab;importance];
%     index_skill = data_test(:,1)==skills(id_skill);
    result_predict = RF.predict(data_test);
    residual_skill =[result_test-result_predict];
%     end
%     r2_tol = [r2_tol,rsquared(result_predict,result_test)];
    rmse = [rmse,(mean(residual_skill.^2))^0.5];
    residual_all{i} = [residual_all{i};residual_skill];
%     length(residual)
end
importance_tol=[importance_tol;mean(importance_tab,1)];

end
