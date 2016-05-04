% Preprocess data and generate covariates for the dataset

% Input: csv files of assistments skill builders
% Output: Organized MAT file with student and skill covariates

% Data filter
% 1. One group division for all 3 model cross validation
% 2. Firstly select skills with at least 10 students, then select students
% with at least 3 skills, then select skills with at least 3 students.

clc;
clear all;
close all;

%% Read in data
% order, skill_id, student_id, correct,
% attempt_count, hint_used, hint_total, first_response_time, first_action, student_class_id, teacher_id,
% school_id,

source_name = {'AS_SB_2009_2010','AS_SB_2010_2011','AS_SB_2011_2012','AS_SB_2012_2013',...
    'AS_SB_2013_2014'};

save_name = {'AS_2009', 'AS_2010', 'AS_2011','AS_2012','AS_2013'};

for id_file = 1:5
file_name = strcat(source_name{id_file},'.csv');

data = dlmread(file_name,';',1,0);

i_order = 1;
i_skill =2;
i_student = 3;
i_correct = 4;
% i_attempt = 5;
% i_hint_used = 6;
% i_hint_total = 7;
% i_time = 8;
% i_action = 9;
% i_class = 10;
% i_teacher = 11;
% i_school = 12;

%% Preprocess data
% We would like to know the influence of student_id and skill_id on FIRST
% ITEM, AVERAGE SCORE, MASTERY SPEED, WHEEL SPINNING. Data set needs to be
% reformed as:
% skill_id, student_id, ...(covariant of skills and students)..., opportunity count (OC), max OC, correct, average correct in this
% skill, mastery speed (-1 for not mastery cases), wheel spinning(1 for yes, 0 for no, -1 for
% indeterminate)
data_new=[];
skills = unique(data(:,i_skill));
num_skills = length(skills);
for id_skill = 1:num_skills
    index = data(:,i_skill)==skills(id_skill);
    subdata = data(index,:);
    students = unique(subdata(:,i_student));
    num_students = length(students);
    if num_students>=10 % Each skill has at least 10 students
        for id_student = 1:num_students
            index = subdata(:,i_student)==students(id_student);
            subsubdata = subdata(index,:);
            subsubdata = sortrows(subsubdata,i_order);
            maxOC = size(subsubdata,1);
            if maxOC >2 % Each student has at least 3 items in each skill
                mastery_speed = mastery_speed_calculator(subsubdata(:,i_correct));
                wheel_spin = wheel_spin_detector(subsubdata(:,i_correct));
                subdata_new = [subsubdata(:,i_skill),subsubdata(:,i_student),(-1)*ones(maxOC,1),(-1)*ones(maxOC,1),...
                    (-1)*ones(maxOC,1),(-1)*ones(maxOC,1),(-1)*ones(maxOC,1),(-1)*ones(maxOC,1),(-1)*ones(maxOC,1),(-1)*ones(maxOC,1),...
                    [1:maxOC]',maxOC*ones(maxOC,1),subsubdata(:,i_correct),...
                    mastery_speed*ones(maxOC,1),wheel_spin*ones(maxOC,1)];
                data_new = [data_new;subdata_new];
            end
        end
    end
end

i_skill =1;
i_student = 2;
i_skillc = 3;
i_studentc = 4;
i_skillf = 5;
i_studentf = 6;
i_skillm = 7;
i_studentm = 8;
i_skillw = 9;
i_studentw = 10;
i_oc = 11;
i_maxoc = 12;
i_correct = 13;
i_ms = 14;
i_ws = 15;
i_cross = 16;

crossvl = 10;
data_new = [data_new,-1*ones(size(data_new,1),1)];

% Change mastery speed to log(ms)
index = data_new(:,i_ms)>0;
data_new(index,i_ms) = log(data_new(index,i_ms));


data_trim=[];
skills = unique(data_new(:,i_skill));
num_skills = length(skills);
% Each student has at least 3 skills
for id_skill = 1:num_skills
    index = data_new(:,i_skill)==skills(id_skill);
    subdata = data_new(index,:);
    students = unique(subdata(:,i_student));
    num_students = length(students);
    if num_students>9
        data_trim=[data_trim;subdata];
    end
end
data_new = data_trim;


data_trim=[];
students = unique(data_new(:,i_student));
num_students = length(students);
% Each skill has at least 3 students
for id_student = 1:num_students
    index = data_new(:,i_student)==students(id_student);
    subdata = data_new(index,:);
    skills = unique(subdata(:,i_skill));
    num_skills = length(skills);
    if num_skills>2
        data_trim=[data_trim;subdata];
    end
end
data_new = data_trim;

% Each skill has how many students?
skills = unique(data_new(:,i_skill));
num_skills = length(skills);
nums= [];
for id_skill = 1:num_skills
    index = data_new(:,i_skill)==skills(id_skill);
    subdata = data_new(index,:);
    students = unique(subdata(:,i_student));
    num_students = length(students);
    if num_students<10
        nums = [nums, num_students];
    end
end
nums
end
for a = 1

% Covariate for student
students = unique(data_new(:,i_student));
num_students = length(students);
for id_student = 1:num_students
    index = data_new(:,i_student)==students(id_student);
    subdata = data_new(index,:);
    data_new(index,i_studentc) = mean(subdata(:,i_correct));
    data_new(index,i_studentf) = mean(subdata(subdata(:,i_oc)==1,i_correct));
    data_new(index,i_studentm) = mean(subdata(subdata(:,i_ms)~=-1 & subdata(:,i_oc)==1,i_ms));
    data_new(index,i_studentw) = mean(subdata(subdata(:,i_ws)~=-1 & subdata(:,i_oc)==1,i_ws));
    
end

% Covariate for skill
skills = unique(data_new(:,i_skill));
num_skills = length(skills);
for id_skill = 1:num_skills
    index = data_new(:,i_skill)==skills(id_skill);
    subdata = data_new(index,:);
    data_new(index,i_skillc) = mean(subdata(:,i_correct));
    data_new(index,i_skillf) = mean(subdata(subdata(:,i_oc)==1,i_correct));
    data_new(index,i_skillm) = mean(subdata(subdata(:,i_ms)~=-1 & subdata(:,i_oc)==1,i_ms));
    data_new(index,i_skillw) = mean(subdata(subdata(:,i_ws)~=-1 & subdata(:,i_oc)==1,i_ws));
end

% Groups for 10 fold cross validation
index = data_new(:,i_oc)==1;
data_new(index, i_cross) = crossvalind('Kfold', sum(index), crossvl);
skills = unique(data_new(:,i_skill));
num_skills = length(skills);

for id_skill = 1:num_skills
    index = data_new(:,i_skill)==skills(id_skill);
    students = unique(data_new(index,i_student));
    num_students = length(students);
    for id_student = 1:num_students
        index = data_new(:,i_student)==students(id_student) & data_new(:,i_skill)==skills(id_skill);
        subdata = data_new(index,:);
        crossvl = subdata(subdata(:,i_oc)==1,i_cross);
        data_new(index,i_cross) = crossvl;
    end
end



if sum(data_new(:,i_skillc)==-1)
    disp('error')
end

if sum(data_new(:,i_studentc)==-1)
    disp('error')
end

if sum(data_new(:,i_cross)==-1)
    disp('error')
end

save(save_name{id_file}, 'data_new');
end
