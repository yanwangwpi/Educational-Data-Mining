% This function is used to calculate the correlation of constructions

clc;
clear all;
close all;

file_name={'AS_2009','AS_2010','AS_2011','AS_2012','AS_2013','Algebra_2005','Algebra_2006',...
'physics_fall2005','physics_fall2006','physics_fall2007','physics_fall2008','physics_fall2009',...
'physics_spring2006','physics_spring2007','physics_spring2008','physics_spring2009','physics_spring2010'};

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


for id = 1:length(file_name)
    load (file_name{id});
    len = size(data_new,1);
    first_item = zeros(len,1);
    
    index = find(data_new(:,i_oc)==1);
    first_once = data_new(index,i_correct);
    for id_index = 1:length(index)-1
        first_item(index(id_index):index(id_index+1)-1) = first_once(id_index);
    end
    first_item(index(id_index+1):end) = first_once(id_index+1);
    correct = data_new(:,i_correct);
    ms = data_new(:,i_ms);
    index = ms==-1;
    ms(index) = nan;
    ws = data_new(:,i_ws);
    index = ws==-1;
    ws(index) = nan;
    
    construction = [correct,first_item,ms,ws];
    [R{id}, P{id}] = corrcoef(construction, 'rows', 'pairwise');
    
end



