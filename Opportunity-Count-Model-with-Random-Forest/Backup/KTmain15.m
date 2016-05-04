% MAIN

% build model
bnet = make_knowledge_model15();

% 1order_id	2assignment_id	3student_id	4correct	5attempt_count	6ms_first_response	
% 	7hint_countpercentage	8sequence_id	9action_1
% 10action_2	1action_3	12action_4	13action_5, 14historyAll, 15historySkill, 16NPC

%% Read file
% order_id	student_id	sequence_id	correct	attempt_count	ms_first_response	hint_count	hint_total	first_action

data = csvread('SkillBuilder2012.csv',1,0);

i_ord = 1;
i_stu=2;
i_skill=3;
i_correct = 4;
i_npc = 5;
i_opp=6;

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

% Get Next Problem Correctness
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
data = [data(:,1:4), NPC,OPP];

index = data(:,i_opp)<=15;
data = data(index,:);

index = find(~isnan(data(:,i_npc)));
data = data(index,:);

dataLen = size(data,1);
skill_ids = unique(data(:,i_skill)); 


r2_tol=[];



residual_tab=[];
rmse = [];
for fold = 1:5
cur_tol = [];
pred_tol =[];
actual_tol=[];
    for id_skill = 1:length(skill_ids)
    index = data(:,i_skill)==skill_ids(id_skill);
    
    subdata = data(index,:);
    indices = mod(subdata(:,i_stu),5)+1;
% sample data one row at a time
    test = indices==fold;
    train = ~test;
    if sum(test)>0 & sum(train)>0
    actual = subdata(test,i_npc);
    
    [train_data, test_data] = get_data(subdata, bnet,test,train);
    bnet_with_learned_parameters = fit_parameters(bnet, train_data);
    [cur, pred, oppc] = predict_data(bnet_with_learned_parameters, test_data);
    cur_tol = [cur_tol;cur];
    pred_tol = [pred_tol;pred,oppc];
    actual_tol=[actual_tol;actual];
    end

    end
%     length(pred_tol)
%     r2_tol = [r2_tol,rsquared(actual_tol,pred_tol)];
    residual = actual_tol-pred_tol(:,1);
%     residual_tab = [residual_tab;residual];
    rmse = [rmse,(nanmean(residual.^2))^0.5];
    rmse_tol{fold} = [actual_tol,pred_tol];
end
save rmse_tol rmse_tol 

