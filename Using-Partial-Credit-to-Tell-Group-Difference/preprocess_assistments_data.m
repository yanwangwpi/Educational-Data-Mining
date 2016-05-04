%  Preprocess 6 big skill builders
clear all;
clc;

seqID = {'10265','6921','10195','11898','11829','11893'};
seqIDnum = [10265,6921,10195,11898,11829,11893];

for id_seq = 1:6
data = dlmread(strcat('SB',seqID{id_seq}, '.csv'),',',1,0);


i_ord = 1;
i_assign = 2;
i_stu = 3;
i_prob = 5;
i_origin = 6;
i_correct = 7;
i_att = 8;
i_seq = 9;
i_class =10;
i_teacher = 11;
i_school = 12;
i_hint = 13;
i_hall = 14;
i_time = 16;
i_prior_count = 17;
i_prior_correct = 18;


index = data(:,i_origin)==1;
data = data(index,:);
index = data(:,i_seq)==data(:,i_seq);
data = data(index,:);

% % z score response time
% num_outlier = 0;
% problems = unique(data(data(:,i_seq) == 11898,i_prob));
% for id = 1:length(problems)
%     index = data(:,i_prob)==problems(id) & data(:,i_correct)==1 & data(:,i_time)~=0;
%     time_seq = data(index,i_time);
%     [time_seq_tmp,index_normal] = get_rid_outlier(time_seq);
%     index_outlier = ~index_normal;
%     num_outlier = num_outlier+sum(index_outlier);
%     stdv = std(time_seq_tmp);
%     meanv = mean(time_seq_tmp);
%     time_seq(index_outlier) = nan;
%     time_seq = (time_seq-meanv)/stdv;
%     data(index,i_time) = time_seq;
%     index = data(:,i_prob)==problems(id) & (data(:,i_correct)~=1 | data(:,i_time)==0);
%     data(index,i_time) = nan;
% end


data_new=[];

students = unique(data(:,i_stu));
max_num = 15;

for id_stu = 1:length(students)
    index_stu = data(:,i_stu)==students(id_stu);
    data_stu_ind = data(index_stu,:);
    data_stu_ind = sortrows(data_stu_ind,[i_ord]);
    num = size(data_stu_ind,1);
    if num>=max_num
        data_stu_ind = data_stu_ind(1:max_num,:);
        num = max_num;
    end

    if num == max_num
        blank = [];
    else
        blank = ones(1,max_num-num)*nan;
    end
    data_new = [data_new;seqIDnum(id_seq),students(id_stu),num,...
        data_stu_ind(1,i_prior_count),...
        data_stu_ind(1,i_prior_correct)/data_stu_ind(1,i_prior_count),...
        data_stu_ind(:,i_correct)',blank,...
        data_stu_ind(:,i_hint)',blank, data_stu_ind(:,i_hall)',blank,...
        data_stu_ind(:,i_att)',blank,  data_stu_ind(:,i_time)',blank];
end 


save(strcat('data_new',seqID{id_seq}), 'data_new');
end





