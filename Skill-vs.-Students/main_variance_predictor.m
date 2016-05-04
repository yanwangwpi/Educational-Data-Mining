clc;
clear all;
close all;

file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006','physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009','physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

student_predictor_var = [];
skill_predictor_var = [];
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

student_predictor_var = [student_predictor_var;...
nanvar(data_new(:,i_studentc)),...
nanvar(data_new_1(:,i_studentf)),...
nanvar(data_new_1(:,i_studentm)),...
nanvar(data_new_1(:,i_studentw))]

skill_predictor_var = [skill_predictor_var;...
nanvar(data_new(:,i_skillc)),...
nanvar(data_new_1(:,i_skillf)),...
nanvar(data_new_1(:,i_skillm)),...
nanvar(data_new_1(:,i_skillw))]

end
