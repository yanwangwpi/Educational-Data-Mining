% No opp, with sucess and failure as features

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
        historySuc(index(1),1) = data(index(1),i_correct);
        historySuc(index(1),2) =1;
        for i = 2:indexLength
            historySuc(index(i),1) = historySuc(index(i-1),1)+data(index(i),i_correct);
            historySuc(index(i),2) = historySuc(index(i-1),2)+1;
        end
   end
end

data = [data,historySuc(:,2)-historySuc(:,1),historySuc(:,1)];

% change hints number to percentage, and bin to 11 bins[0,0.1,0.2,...,1]
indexHintNon0 = find(data(:,i_h_total)~=0);
hintPercentage = zeros(size(data,1),1);
hintPercentage(indexHintNon0) = data(indexHintNon0,i_h_count)./data(indexHintNon0,i_h_total);
index = find(isnan(hintPercentage));
hintPercentage(index)=0;

data = [data(:,[1,2,3,4,5,6]),hintPercentage,data(:,9:11)];
i_hint = 7;
i_action = 8;
i_f = 9;
i_s = 10;

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
i_att=6;
i_time = 7;
i_hint = 8;
i_action = 9;
i_correct = 5;
i_f = 10;
i_s = 11;
% For RF we need to get rid of data with no NPC
index = find(~isnan(NPC));
data = data(index,:);
NPC = NPC(index);

% % put previous info in a row. For opp=2, append info in opp=1; for opp=3,
% % append info in opp=1 and 2; ect.
% skills = unique(data(:,i_skill));
% OPP=[];
% PPF=[];
% % 9OPP 1order_id	2student_id	3sequence_id	4correct	5attempt_count
% % 6ms_first_response	7hint_per 8first_action
% 
% prev = 5;
% for id = 1:length(skills)
%     index = data(:,i_skill)==skills(id);
%     subdata = data(index,:);
%     students = unique(subdata(:,i_stu));
%     
%     for id2 = 1: length(students)
%         index = subdata(:,i_stu)==students(id2);
%         subsub = subdata(index,:);
%         eachppf=[];
%         subsub(find(subsub(:,i_att)==0),6:9)=nan;
%         if sum(index)~=0
%         %previous problem feature
%         
%         ppf = subsub(:,5:8);
%         tmpppf=[];
%         for num = 1:sum(index)    
%             if num<prev+1
%                 ppf2 = ppf(1:num,:);
%             else
%                 ppf2 = ppf(1:prev+1,:);
%             end
%             ppf2 = round(nanmean(ppf2,1)*10)/10;
%             tmpppf =[tmpppf;[ppf2]];
%         end
%         eachppf = [eachppf,tmpppf];
%         
%         ppf = subsub(:,9);
%         tmpppf=[];
%         for num = 1:sum(index)    
%             if num<prev+1
%                 ppf2 = ppf(1:num,:);
%             else
%                 ppf2 = ppf(1:prev+1,:);
%             end
%             ppf2 = mode(ppf2,1);
%             tmpppf =[tmpppf;[ppf2]];
%         end
%         eachppf = [eachppf,tmpppf];
%         end
%         PPF=[PPF;eachppf];
%     end
% end
% data = [data(:,1:4),PPF];
%% Random Forest
% N fold cross validation
N = 5;
% # of tree we build
nTree = 100;
data_origin = data;

rmse = [];
% find opp=1
for i = 1:N
residual_all{i}=[];
end
for oppor = 1:6
index = data_origin(:,i_opp)==oppor;% | data_origin(:,i_opp)==2 | data_origin(:,i_opp)==3;
data = data_origin(index,:);

% indices = crossvalind('Kfold', dataLen, N);
indices = mod(data(:,i_stu),N)+1;
residual_tab=[];
importance_tab = [];

r2_tol=[];
for i = 1
    test = (indices == i);
    train = ~test;
    
    data_train = data(train,4:end);
    result_train = NPC(train);
    data_test = data(test,4:end);
    result_test = NPC(test);
% i_skill=4;
% i_att=6;
% i_time = 7;
% i_hint = 8;
% i_action = 9;
% i_correct = 5;
% i_f = 10;
% i_s = 11;    
    indicator = [false, false,false,false,true,false,false];
    
    skills = unique(data_train(:,1));
    residual_skill=[];
    for id_skill = 1:length(skills)
        index_skill = data_train(:,1)==skills(id_skill);
        err_tol=[];
    for NFeature = 2:2:6
        RF = TreeBagger(nTree,data_train(index_skill,2:end),result_train(index_skill),'method','regression','oobpred','on','oobvarimp','on',...
            'CategoricalPredictors', indicator,'NVarToSample',NFeature );
        tmp =  oobError(RF);
        err_tol=[err_tol,tmp(end)];
    end
    [val,I ] = min(err_tol);
    NF = I*2
%     NF = 2;
    RF = TreeBagger(nTree,data_train(index_skill,2:end),result_train(index_skill),'method','regression','oobpred','on','oobvarimp','on',...
        'CategoricalPredictors', indicator,'NVarToSample',NF );
    importance = RF.OOBPermutedVarDeltaError;
    importance_tab = [importance_tab;importance];
    index_skill = data_test(:,1)==skills(id_skill);
    result_predict = RF.predict(data_test(index_skill,2:end));
    residual_skill =[residual_skill;result_test(index_skill)-result_predict];
    end
%     r2_tol = [r2_tol,rsquared(result_predict,result_test)];
    rmse = [rmse,(mean(residual_skill.^2))^0.5];
    residual_all{i} = [residual_all{i};residual_skill];
%     length(residual)
end

end
