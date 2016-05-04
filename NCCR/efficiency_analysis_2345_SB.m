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
% Build such a table 2*4
% 1. # of student who reach this level
% 2. # of total items needed to reach this level
N = 5;
table = zeros(1,6);
for id = 1:6
    time_all{id}=[];
end

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
        [tell,index1] = findseq(cor_seq,N);
        if tell
            table(1) = table(1)+1;
            time_all{1} = [time_all{1},index1-1];
        else
            [tell,index1] = findseq(cor_seq,N-1);
            if tell
                table(2) = table(2)+1;
                time_all{2} = [time_all{2},sum(index)];
            else
                [tell,index1] = findseq(cor_seq,N-2);
                if tell
                    table(3) = table(3)+1;
                    time_all{3} = [time_all{3},sum(index)];
                else
                    [tell,index1] = findseq(cor_seq,N-3);
                    if tell
                        table(4) = table(4)+1;
                        time_all{4} = [time_all{4},sum(index)];
                    else
                        [tell,index1] = findseq(cor_seq,N-4);
                        if tell
                            table(5) = table(5)+1;
                            time_all{5} = [time_all{5},sum(index)];
                        else
                            table(6) = table(6)+1;
                            time_all{6} = [time_all{6},sum(index)];
                        end
                    end
                end
                
                
            end
        end
    end
end

sta_time =[];
time_all{4} = [time_all{4},time_all{5},time_all{6}];
for id = 1:4
    m = mean(time_all{id});
    s = std(time_all{id});
    sta_time =[sta_time;m,s];
end
    


