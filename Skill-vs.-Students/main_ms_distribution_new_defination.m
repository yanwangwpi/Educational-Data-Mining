clc;
clear all;
close all;

file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006','physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009','physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

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

ncorrect = 2;

mastery_speed_all = [];
pairs = unique(data_new(:,[i_skill,i_student]),'rows');
for id_pair = 1:length(pairs)
    index = data_new(:,i_skill)==pairs(id_pair,1) & data_new(:,i_student)==pairs(id_pair,2);
    mastery_speed = mastery_speed_calculator_ncorrect(data_new(index,i_correct),ncorrect);
    mastery_speed_all = [mastery_speed_all;mastery_speed];
end

ms = mastery_speed_all(mastery_speed_all~=-1);

maxms = max(ms);
countms = zeros(1,maxms);
for idms = 1:maxms
    countms(idms) = sum(ms<=idms);  
end
% ms_distro{id} = [size(data_new_1,1),countms(3:end)];
% ms_distro_perct{id} = countms(3:end)./size(data_new_1,1);
ms_distro{id} = [size(ms,1),countms(ncorrect:end)];
ms_distro_perct{id} = countms(ncorrect:end)./size(mastery_speed_all,1);
end

cutoff = 21;
ms_distro_table = [];
ms_distro_perct_table = [];
for id = 1:length(file_name)
    this_ms = ms_distro{id};
    ms_distro_table = [ms_distro_table;this_ms(1:cutoff)];
    this_ms_perct = ms_distro_perct{id};
    ms_distro_perct_table = [ms_distro_perct_table;this_ms_perct(1:cutoff-1)];
end
