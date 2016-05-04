
clear all;
clc;

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

%% Find the # of priors of each skill of each student
stu_skill_prior_num = [];
students = unique(data(:,i_stu));
for id_stu = 1:length(students)
    index = data(:,i_stu)==students(id_stu);
    subdata = data(index,:);
    skills = unique(subdata(:,i_seq));
    for id_skill = 1:length(skills)
        index = subdata(:,i_seq)==skills(id_skill);
        subsubdata = subdata(index,:);
        minord = min(subsubdata(:,i_ord));
        index = subdata(:,i_ord)<minord;
        priornum = sum(index);
        prior = sum(subdata(index,i_correct))/priornum;
        stu_skill_prior_num = [stu_skill_prior_num; students(id_stu),skills(id_skill),prior,priornum];
    end
end

save stu_skill_prior_num stu_skill_prior_num;

%% Convergence of skill data format

data_new=[];

students = unique(data(:,i_stu));
max_num = 15;

for id_stu = 1:length(students)
    index_stu = data(:,i_stu)==students(id_stu);
    subdata = data(index_stu,:);
    skills = unique(subdata(:,i_seq));
    for id_seq = 1:length(skills)
        index = subdata(:,i_seq)==skills(id_seq);
        subsubdata = subdata(index,:);
        subsubdata = sortrows(subsubdata,[i_ord]);
        num = size(subsubdata,1);
        if num>=max_num
            subsubdata = subsubdata(1:max_num,:);
            num = max_num;
        end
        if num == max_num
            blank = [];
        else
            blank = ones(1,max_num-num)*nan;
        end
        
        index = stu_skill_prior_num(:,1)== students(id_stu) & stu_skill_prior_num(:,2)== skills(id_seq);
        data_new = [data_new;skills(id_seq),students(id_stu),num,...
            stu_skill_prior_num(index,4),...
            stu_skill_prior_num(index,3),...
            subsubdata(:,i_correct)',blank,...
            subsubdata(:,i_hint)',blank, ...
            subsubdata(:,i_att)',blank];
        
    end 
    
    
end

save algebra_data data_new;









