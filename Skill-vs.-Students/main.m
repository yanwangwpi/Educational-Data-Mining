% This file is the main file that combine results together.

clc;
clear all;
close all;

stats =[];
assess_student=[];
assess_skill=[];
assess_student_skill=[];
unique_st=[];
unique_sk =[];
mutual=[];
percent_mu =[];

file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006',...
'physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009',...
'physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};


for id = 1:length(file_name)
[student_skill_pair,assess_best1] = func_student_covariate(file_name{id});
stats =[stats;student_skill_pair];
assess_student=[assess_student;assess_best1];

[student_skill_pair,assess_best2] = func_skill_covariate(file_name{id});
assess_skill=[assess_skill;assess_best2];

[student_skill_pair,assess_best3] = func_student_skill_covariate(file_name{id});
assess_student_skill=[assess_student_skill;assess_best3];

mutual_this = assess_best1+assess_best2-assess_best3;
st_this=assess_best1-mutual_this;
sk_this = assess_best2-mutual_this;
mutual = [mutual;mutual_this];
unique_st = [unique_st;st_this];
unique_sk = [unique_sk;sk_this];
percent_mu = [percent_mu;mutual_this./(mutual_this+st_this+sk_this)];

end

% assess_best = [table_test.r2(1,1),table_test.r2mc(1,1),table_test.r2ef(1,1),table_test.rmse(1,1),table_test.auc(1,1),table_test.var(1,1),nanmean(data_new(:,i_correct)),table_test.rmse(1,1)^2/(1-table_test.r2ef(1,1)),...
%     table_test.r2(2,2),table_test.r2mc(2,2),table_test.r2ef(2,2),table_test.rmse(2,2),table_test.auc(2,2),table_test.var(2,2),nanmean(data_new_1(:,i_correct)),table_test.rmse(2,2)^2/(1-table_test.r2ef(2,2)),...
%     table_test.r2(3,3),table_test.r2ef(3,3),table_test.rmse(3,3),table_test.var(3,3),nanmean(data_new_1(data_new_1(:,i_ms)~=-1,i_ms)),table_test.rmse(3,3)^2/(1-table_test.r2ef(3,3)),...
%     table_test.r2(4,4),table_test.r2mc(4,4),table_test.r2ef(4,4),table_test.rmse(4,4),table_test.auc(4,4),nanmean(data_new_1(data_new_1(:,i_ws)~=-1,i_ws)),table_test.var(4,4),table_test.rmse(4,4)^2/(1-table_test.r2ef(4,4))];

unique_stt = unique_st(:,[1:3,9:11,17,18,23:25]);
unique_skk = unique_sk(:,[1:3,9:11,17,18,23:25]);
mutuall = mutual(:,[1:3,9:11,17,18,23:25]);
percent_muu = percent_mu(:,[1:3,9:11,17,18,23:25]);

