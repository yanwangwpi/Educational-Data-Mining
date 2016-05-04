% This file is used to get stats of data_new_covariateX
clc;
clear all;
close all;

%% The "Read in data" and "Preprocess data"  can be replaced if data is already generated
load data_new_covariate2_2013_half;

%% New index
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
% i_studentvlc = 16;
% i_studentvlf = 17;
% i_skillvlc = 18;
% i_skillvlf = 19;

% for data_new_covariate2
i_studentvlc = 16;
i_studentvlf = 16;
i_skillvlc = 16;
i_skillvlf = 16;

%% stats of this data set
% # of students
students = unique(data_new(:,i_student));
num_student = length(students);
% # of skills
skills = unique(data_new(:,i_skill));
num_skill = length(skills);

% mean # skills for each student
student_skillnum=[];
for id_student = 1:num_student
    index = data_new(:,i_student)==students(id_student);
    subdata = data_new(index,:);
    student_skillnum = [student_skillnum;students(id_student),length(unique(subdata(:,i_skill)))];
end
mean(student_skillnum(:,2))
std(student_skillnum(:,2))
% mean # students for each skill
skill_stunum=[];
for id_skill = 1:num_skill
    index = data_new(:,i_skill)==skills(id_skill);
    subdata = data_new(index,:);
    skill_stunum = [skill_stunum;skills(id_skill),length(unique(subdata(:,i_student)))];
end
mean(skill_stunum(:,2))
std(skill_stunum(:,2))
save student_skillnum_2013_200000 student_skillnum
save skill_stunum_2013_200000 skill_stunum
    

