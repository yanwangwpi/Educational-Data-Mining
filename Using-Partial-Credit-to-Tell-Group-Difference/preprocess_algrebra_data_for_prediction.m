clc;
close all;
clear all;
load algebra_2005_2006_raw_data;
% data = [row, start_time opps_id,skills_id,users_id,double(correct_first), double(corrects), double(incorrects), double(hints)];

i_ord = 2;
i_opp = 3;
i_seq = 4;
i_stu = 5;
i_correct = 6;
i_corrects = 7;
i_incorrects = 8;
i_hint = 9;
i_att = 10;

data = [data, data(:,i_corrects)+data(:,i_incorrects)];

limit  = 3;

%% Each student has at least 3 items in each skill
skills = unique(data(:,i_seq));
data_new=[];
limit=3;
drop_num = 0;
for id_skill = 1:length(skills)
    index = data(:,i_seq) == skills(id_skill);
    data_stu = data(index,:);
    stu = unique(data_stu(:,i_stu));
    
    for id_stu = 1:length(stu)
        index = data_stu(:,i_stu)==stu(id_stu);
        if sum(index)>=limit
            data_new = [data_new;data_stu(index,:)];
        else
            drop_num = drop_num+1;
        end
    end
end

data = data_new;

data = sortrows(data, [i_stu, i_seq, i_ord]);
%% Convergence of students data format
% Correct_table(student_id,sequence_id,problem_id, correct)
% Feature_table(student_id, hint_usage, hint_toal, attempt, time)

%Filter: Each student has 10 sequences at least.
data_new1=[];
correct_table=[];
feature_table=[];

limit_stu = 30;
drop_num_stu=0;
stu = unique(data(:,i_stu));
    
for id = 1:length(stu)
    index = data(:,i_stu)==stu(id);
    sub = data(index,:);
    skills = unique(sub(:,i_seq));
    skills  =skills(skills==skills);
    correct_tmp = [];
    feature_tmp = [];
    if length(skills)>=limit_stu
        data_new1 = [data_new1;sub];
        subskills = datasample(skills,limit_stu,'Replace',false);
        for id2 = 1:length(subskills);
            index = sub(:,i_seq)==subskills(id2);
            subsub = sub(index,:);
            subsub = sortrows(subsub,i_ord);
            correct_tmp = [correct_tmp;subsub(1:limit,[i_seq,i_correct])];
            feature_tmp = [feature_tmp;subsub(1:limit,[i_hint,i_att])];
        end
    else
        drop_num_stu = drop_num_stu+1;
    end
    if size(correct_tmp,1)~=0
    correct_table = [correct_table;[stu(id),correct_tmp(:)']];
    feature_table = [feature_table;[stu(id),feature_tmp(:)']];
    end
end

save correct_table_algebra correct_table;
save feature_table_algebra feature_table;

