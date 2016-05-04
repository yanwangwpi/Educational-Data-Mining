% This file is used to analyze whether 4th is correct after 3ccr

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
if sum(index)~=size(data,1)
    disp('error');
end
data = data(index,:);


data = sortrows(data,[i_assn,i_user,i_ord]);
% Build such a table 4*2
% column 1 KT>0.95; 2 KT<0.95
% 1. # of student who 1,1,1,0
% 2. # of students who 1,1,1,1
% 3. # of students who ?,1 1 1 0
% 4. # of students who ?,1 1 1 1

% [24,5;231,27;19,28;187,90]

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
        [tell,index1] = findseq(cor_seq(1:end-1,i_cor),N);
        if tell
            stu_3ccr = stu_3ccr+1;
            if index1 == N+1
                if cor_seq(index1-1,i_KT)>=0.95
                    table(1+cor_seq(index1,i_cor),1) = table(1+cor_seq(index1,i_cor),1)  + 1;
                else
                    table(1+cor_seq(index1,i_cor),2) = table(1+cor_seq(index1,i_cor),2) + 1;
                end
            else
                if cor_seq(index1-1,i_KT)>=0.95
                    table(3+cor_seq(index1,i_cor),1) = table(3+cor_seq(index1,i_cor),1) + 1;
                else
                    table(3+cor_seq(index1,i_cor),2) = table(3+cor_seq(index1,i_cor),2) + 1;
                end
            end
        end
    end
end
                
      
                