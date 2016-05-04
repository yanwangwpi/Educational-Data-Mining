% This file is used to calcualte the 4th and 5th question after 3CCR

clc;
clear all;

data =xlsread('prun_data_KT.xlsx');
% order_id	assignment_id	student_id	original	correct	sequence_id 	KT

i_ord = 1;
i_assn = 2;
i_user = 3;
i_org = 4;
i_cor = 5;
i_seq = 6;
i_KT = 7;

index = data(:,i_org)==1;
data = data(index,:);

data = sortrows(data,[i_assn,i_user,i_ord]);
% Build such a table 2*3
% column inital or later 1,1,1
% 1.0,0
% 2. 0,1
% 3. 1,0
% 4. 1,1


N = 3;
table = zeros(4,2);
% time_all = zeros(1,N);
stu_all=0;
stu_3ccr = 0;
assn = unique(data(:,i_assn));

for id = 1:length(assn)
    index = data(:,i_assn)==assn(id);
    sub = data(index,:);
    stu = unique(sub(:,i_user));
    for id_s = 1:length(stu)
        stu_all = stu_all+1;
        index = sub(:,i_user)==stu(id_s);
        cor_seq = sub(index,:);
        [tell3,tell4,tell5,index1] = findpattern(cor_seq(:,i_cor));
        col = ~(index1==N+1);
        col = col+1;
        if tell3
            rown = tell4*2 + tell5+1;
            table(rown,col) = table(rown,col)+1;
        end       
        
    end
end


