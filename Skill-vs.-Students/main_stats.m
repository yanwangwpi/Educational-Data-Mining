% This file is the main file to get stats of data sets.

clc;
clear all;
close all;


file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006',...
'physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009',...
'physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

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

stats=[];
for id = 1:length(file_name)
    load (file_name{id});
    data_new_1 = data_new(data_new(:,i_oc)==1,:);
    student_skill_pair=[length(unique(data_new_1(:,i_student))),length(unique(data_new_1(:,i_skill))),size(data_new_1,1),size(data_new,1)];
    stats =[stats;student_skill_pair];
end