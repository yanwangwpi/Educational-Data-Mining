clc;
clear all;
close all;

% 'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006',
file_name={'physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009','physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

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
mslog = data_new_1(:,i_ms);
mslog = mslog(mslog~=-1);
ms = round(exp(mslog));

maxms = max(ms);
countms = zeros(1,maxms);
for idms = 1:maxms
    countms(idms) = sum(ms<=idms);  
end
% ms_distro{id} = [size(data_new_1,1),countms(3:end)];
% ms_distro_perct{id} = countms(3:end)./size(data_new_1,1);
ms_distro{id} = [size(ms,1),countms(3:end)];
ms_distro_perct{id} = countms(3:end)./size(ms,1);
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
