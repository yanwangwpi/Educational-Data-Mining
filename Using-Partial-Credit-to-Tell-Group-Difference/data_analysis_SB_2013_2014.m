
clear all;
clc;

data = dlmread('assistments_data_SB_2013_2014.csv',',',1,0);

% order_id, assignment_id, user_id, assistment_id, problem_id, original, correct, attempt_count, sequence_id,student_class_id,
% teacher_id, school_id, hint_count, hint_total, first_action, ms_first_response 
i_ord = 1;
i_assign = 2;
i_stu = 3;
i_prob = 5;
i_origin = 6;
i_correct = 7;
i_att = 8;
i_seq = 9;
i_class =10;
i_teacher = 11;
i_school = 12;
i_hint = 13;
i_hall = 14;
i_time = 16;

index = data(:,i_origin)==1;
data = data(index,:);
index = data(:,i_seq)==data(:,i_seq);
data = data(index,:);

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

%% z score response time
% num_outlier = 0;
% problems = unique(data(:,i_prob));
% for id = 1:length(problems)
%     index = data(:,i_prob)==problems(id) & data(:,i_correct)==1 & data(:,i_time)~=0;
%     index1 = data(:,i_prob)==problems(id) & data(:,i_correct)~=1 & data(:,i_time)~=0;
%     index2 = data(:,i_prob)==problems(id) & data(:,i_time)==0;
%     time_seq = data(index,i_time);
%     [time_seq_tmp,index_normal] = get_rid_outlier(time_seq);
%     index_outlier = ~index_normal;
%     num_outlier = num_outlier+sum(index_outlier);
%     stdv = std(time_seq_tmp);
%     meanv = mean(time_seq_tmp);
%     time_seq(index_outlier) = nan;
%     time_seq = (time_seq-meanv)/stdv;
%     data(index,i_time) = time_seq;
%     data(index1,i_time) = (data(index1,i_time)-meanv)/stdv;
%     data(index2,i_time) = nan;
% end
% save data_2013 data;
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
    correct_tmp = [];
    feature_tmp = [];
    if length(skills)>=limit_stu
        data_new1 = [data_new1;sub];
        subskills = datasample(skills,limit_stu,'Replace',false);
        for id2 = 1:length(subskills);
            index = sub(:,i_seq)==subskills(id2);
            subsub = sub(index,:);
            subsub = sortrows(subsub,i_ord);
            correct_tmp = [correct_tmp;subsub(1:limit,[i_seq,i_prob,i_correct])];
            feature_tmp = [feature_tmp;subsub(1:limit,[i_hint,i_hall,i_att,i_time])];
        end
    else
        drop_num_stu = drop_num_stu+1;
    end
    if size(correct_tmp,1)~=0
    correct_table = [correct_table;[stu(id),correct_tmp(:)']];
    feature_table = [feature_table;[stu(id),feature_tmp(:)']];
    end
end

save correct_table_2013 correct_table;
save feature_table_2013 feature_table;
save data_new1_2013 data_new1;

%% Convergence of skill data format
% Skill_table(sequence_id, student, problem_id..., correct...hint_usage..., hint_toal..., attempt... time…)

%Filter: Each skill has 100 students at least.
data_new2=[];
skill_table=[];

limit_skill = 100;
drop_num_skill=0;
skills = unique(data(:,i_seq));
    
for id = 1:length(skills)
    index = data(:,i_seq)==skills(id);
    sub = data(index,:);
    stu = unique(sub(:,i_stu));
    if length(stu)>=limit_skill
        data_new2 = [data_new2;sub];
        for id2 = 1:length(stu);
            index = sub(:,i_stu)==stu(id2);
            subsub = sub(index,:);
            subsub = sortrows(subsub,i_ord);
            skill_table = [skill_table;skills(id),stu(id2),subsub(1:limit, i_prob)',subsub(1:limit, i_correct)',subsub(1:limit, i_hint)',...
                subsub(1:limit, i_hall)',subsub(1:limit, i_att)',subsub(1:limit, i_time)'];
        end
    else
        drop_num_skill = drop_num_skill+1;
    end
end

save skill_table_2013 skill_table;
save data_new2_2013 data_new2;








