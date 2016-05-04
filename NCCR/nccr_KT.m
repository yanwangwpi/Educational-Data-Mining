% This file is used to calcualte KT at NCCR

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
% column 3ccr, 4ccr, 5ccr
% 1. # for 1,1,1...
% 2. KT>=0.95 for 1,1,1...
% 3. # for ?,1,1,1...
% 4. KT>=0.95 for ?,1,1,1...


N_initial = 2;
table = zeros(4,3);
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
        for col = 1:3
        N = N_initial+col;
        [tell,index1] = findseq(cor_seq(1:end,i_cor),N);
        if tell
            
            if index1 == N+1
                table(1,col) = table(1,col)+1;
                if cor_seq(index1-1,i_KT)>=0.95
                    table(2,col) = table(2,col)+1;
                end
            else
                table(3,col) = table(3,col)+1;
                if cor_seq(index1-1,i_KT)>=0.95
                    table(4,col) = table(4,col)+1;
                end
            end
        end
        end
    end
end
                
      
                
