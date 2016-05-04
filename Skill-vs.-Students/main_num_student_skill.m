% This file gives the distribution of students' skill count, and skills'
% student count
clc;
clear all;
close all;

file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006','physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009','physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

mSkillDistro=[];
mStudentDistro = [];
skillEdge = [0:3:20,inf];
studentEdge = [0:10:80,inf];
for id = 1:length(file_name)
load (file_name{id});
% load AS_2013;
% data_new = data_new(1:196781,:);

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
i_cross = 16;

data_new_1 = data_new(data_new(:,i_oc)==1,:);

students = unique(data_new_1(:,i_student));
nStudents = length(students);
mSkillEach = [];
for id_stu = 1:nStudents
    mSkillEach  =[mSkillEach;sum(data_new_1(:,i_student)==students(id_stu))];
end
x = histc(mSkillEach,skillEdge);
mSkillDistro = [mSkillDistro;x.'];

skills = unique(data_new_1(:,i_skill));
nSkills = length(skills);
mStudentEach = [];
for id_skill = 1:nSkills
    mStudentEach  =[mStudentEach;sum(data_new_1(:,i_skill)==skills(id_skill))];
end
x = histc(mStudentEach,studentEdge);
mStudentDistro = [mStudentDistro;x.'];

end