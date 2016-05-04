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
    'physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'}
% file_name={'physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009','physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

curveall=[];
errorall=[];
numall=[];

for id = 1:length(file_name)
[curve,error,curve_num] = assistment_covariate_opp_func(file_name{id},3,1);
curveall = [curveall;curve;error;curve_num];

end

ratio=[];
for id = 1:length(file_name)
    ratio = [ratio;curveall((id-1)*7+2,:)./curveall((id-1)*7+3,:)];
end



