% This file is used to analyze N correct in a row in skill builder

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

index = data(:,i_org)==1;
data = data(index,:);

data = sortrows(data,[i_assn,i_user,i_ord]);
% Build such a table 11*4
% 1. # of student who reach this level
% 2. # of students who reach next level with 1 more item
% 3. # of students who reach next level with 2 more item
N = 5;
table = zeros(11,N);
time_all = zeros(1,N);
stu_all=0;
assn = unique(data(:,i_assn));
for id = 1:length(assn)
    index = data(:,i_assn)==assn(id);
    sub = data(index,:);
    stu = unique(sub(:,i_user));
    for id_s = 1:length(stu)
        stu_all = stu_all+1;
        index = sub(:,i_user)==stu(id_s);
        cor_seq = sub(index,i_cor);
        [tell,index1] = findseq(cor_seq,3);
        if index1==4
        [tell,index1] = findseq(cor_seq,N);
        if tell
        for len = 1:N
            [tell,index1] = findseq(cor_seq,len);
            if tell
                table(1,len) = table(1,len)+1;
            end
            [tell,index2] = findseq(cor_seq,len+1);
            if tell
                if index2-index1==1
                    time_all(len) = time_all(len)+index2-1;
                end
                if index2-index1+1>11
                    table(11,len) = table(11,len)+1;
                else
                table(index2-index1+1,len) = table(index2-index1+1,len)+1;
                end
            end
        end
        end
        end
    end
end
            
                