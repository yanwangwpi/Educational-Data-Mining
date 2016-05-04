% In this file, we are going to analyze the efficiency of getting more
% practice

clc;
clear all;
close all;

% read data
% [data, text, alldata] = xlsread('NCorrect.xlsx');
%
% alldata = alldata(2:end,:);
%
% i_user = 1;
% i_cor = 7;
% i_pro = 10;
% i_ord = 11;
% i_start = 18;
% i_end = 19;

[data, text, alldata] = xlsread('PSASXWU.xlsx');

i_user = 3;
i_cor = 7;
i_pro = 5;
i_ord = 1;
i_start = 22;
i_end = 23;
i_dur = 24;
% problem_id 1134182, 1134189, 1134191, 1134192 represents 4 conditions

alldata = alldata(2:end,:);
%% Transform data, so as to add conditions

index = data(:,i_pro) == 1134182;
stu1 = data(index,i_user);

index = data(:,i_pro) == 1134189;
stu2 = data(index,i_user);

index = data(:,i_pro) == 1134191;
stu3 = data(index,i_user);

index = data(:,i_pro) == 1134192;
stu4 = data(index,i_user);

data_student=[];
data_new=[];
dur=[];

index = ismember(data(:,i_user),stu1);
data_new = [data_new;ones(sum(index),1),data(index,[i_user,i_cor,i_pro,i_ord])];
% transform time to duration
time_raw = alldata(index,[i_start,i_end]);
for id = 1:size(time_raw,1)
    t = textscan(time_raw{id,1}, '%f/%f/%f %f:%f:%f %s');
    if  strcmpi(t{7},'PM')
        start_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
    else
        start_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
    end
    try
        t = textscan(time_raw{id,2}, '%f/%f/%f %f:%f:%f %s');
        if  strcmpi(t{7},'PM')
            end_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
        else
            end_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
        end
        dur = [dur;end_t-start_t];
    catch
        
        dur = [dur;nan];
    end
    
end

index = ismember(data(:,i_user),stu2);
data_new = [data_new;ones(sum(index),1)*2,data(index,[i_user,i_cor,i_pro,i_ord])];
% transform time to duration
time_raw = alldata(index,[i_start,i_end]);
for id = 1:size(time_raw,1)
    try
        t = textscan(time_raw{id,1}, '%f/%f/%f %f:%f:%f %s');
    catch
        a =1;
    end
    if  strcmpi(t{7},'PM')
        start_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
    else
        start_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
    end
    try
        t = textscan(time_raw{id,2}, '%f/%f/%f %f:%f:%f %s');
        if  strcmpi(t{7},'PM')
            end_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
        else
            end_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
        end
        dur = [dur;end_t-start_t];
    catch
        
        dur = [dur;nan];
    end
    
end


index = ismember(data(:,i_user),stu3);
data_new = [data_new;ones(sum(index),1)*3,data(index,[i_user,i_cor,i_pro,i_ord])];
% transform time to duration
time_raw = alldata(index,[i_start,i_end]);
for id = 1:size(time_raw,1)
    t = textscan(time_raw{id,1}, '%f/%f/%f %f:%f:%f %s');
    if  strcmpi(t{7},'PM')
        start_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
    else
        start_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
    end
    try
        t = textscan(time_raw{id,2}, '%f/%f/%f %f:%f:%f %s');
        if  strcmpi(t{7},'PM')
            end_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
        else
            end_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
        end
        dur = [dur;end_t-start_t];
    catch
        
        dur = [dur;nan];
    end
    
end

index = ismember(data(:,i_user),stu4);
data_new = [data_new;ones(sum(index),1)*4,data(index,[i_user,i_cor,i_pro,i_ord])];
% transform time to duration
time_raw = alldata(index,[i_start,i_end]);
for id = 1:size(time_raw,1)
    t = textscan(time_raw{id,1}, '%f/%f/%f %f:%f:%f %s');
    if  strcmpi(t{7},'PM')
        start_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
    else
        start_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
    end
    try
        t = textscan(time_raw{id,2}, '%f/%f/%f %f:%f:%f %s');
        if  strcmpi(t{7},'PM')
            end_t = datenum(0,t{1},t{2},t{4}+12,t{5},t{6});
        else
            end_t = datenum(0,t{1},t{2},t{4},t{5},t{6});
        end
        dur = [dur;end_t-start_t];
    catch
        
        dur = [dur;nan];
    end
    
end

dur = 24*3600*dur;
data_new = [data_new,dur];

i_sec = 1;
i_user = 2;
i_cor = 3;
i_pro = 4;
i_ord = 5;
i_dur = 6;

%% get rid of intro questions, and divide into sections
data_new = sortrows(data_new,[i_sec,i_user,i_ord]);

N = size(data_new,1);
% post test A 403809,403829, 1134188
% post test B 403325, 403348, 1137670
data=[];

for id = 1:2
    data_sub = data_new(data_new(:,i_sec)==id,:);
    students = unique(data_sub(:,i_user));
    for id_stu = 1:length(students)
        data_sec = data_sub(data_sub(:,i_user)==students(id_stu),:);
        %     get rid of intro question
        data_sec = data_sec(2:end,:);
        subsec = zeros(size(data_sec,1),1);
        index = ismember(data_sec(:,i_pro),[403809,403829, 1134188]);
        index_ones = find(index==1);
        if size(index_ones,1)==0
            subsec(:) = 1+4*(id-1);
            data = [data;data_sec,subsec];
            continue;
        end
        subsec(1:index_ones(1)-1)=1+4*(id-1);
        subsec(index) = 2+4*(id-1);
        index2 = ismember(data_sec(:,i_pro),[403325, 403348, 1137670]);
        index2_ones = find(index2==1);
        if size(index2_ones,1)==0
            subsec(index_ones(end)+1:end)=3+4*(id-1);
            data = [data;data_sec,subsec];
            continue;
        end
        subsec(index_ones(end)+1:index2_ones(1)-1)=3+4*(id-1);
        subsec(index2) = 4+4*(id-1);
        data = [data;data_sec,subsec];
    end
end

for id = 3:4
    data_sub = data_new(data_new(:,i_sec)==id,:);
    students = unique(data_sub(:,i_user));
    for id_stu = 1:length(students)
        data_sec = data_sub(data_sub(:,i_user)==students(id_stu),:);
        %     get rid of intro question
        data_sec = data_sec(2:end,:);
        subsec = zeros(size(data_sec,1),1);
        index = ismember(data_sec(:,i_pro),[403325, 403348, 1137670]);
        index_ones = find(index==1);
        if size(index_ones,1)==0
            subsec(:) = 1+4*(id-1);
            data = [data;data_sec,subsec];
            continue;
        end
        subsec(1:index_ones(1)-1)=1+4*(id-1);
        subsec(index) = 2+4*(id-1);
        index2 = ismember(data_sec(:,i_pro),[403809,403829, 1134188]);
        index2_ones = find(index2==1);
        if size(index2_ones,1)==0
            subsec(index_ones(end)+1:end)=3+4*(id-1);
            data = [data;data_sec,subsec];
            continue;
        end
        subsec(index_ones(end)+1:index2_ones(1)-1)=3+4*(id-1);
        subsec(index2) = 4+4*(id-1);
        data = [data;data_sec,subsec];
    end
end

data_test = data;
save data_test data_test;
i_subsec = 7;

k=1.5;
dur = data(:,i_dur);
cutline = prctile(dur,[25,50,75]);
lower = cutline(1)-k*(cutline(3)-cutline(1));
upper = cutline(3)+k*(cutline(3)-cutline(1));
index = dur<lower;
data(index,i_dur)=lower;
index = dur>upper;
data(index,i_dur)=upper;

% %% Get statistics
% % each row of ptable represents
% % 1.# of students who has done until this opptunity
% % 2. #of correct
% % 3. # of NPC
% % 4. # of students who reach this level
% % 5. # of students who fail this level
% ptable = zeros(5,4);
% for id = 1:4
%     ttable{id}=[];
%     tgoodtable{id} = [];
%     tbadtable{id} = [];
% end
% dropout = 0;
% for subsec = [1,7,9,15]%[3,5,11,13] %1:2:16
%     index = data(:,i_subsec)==subsec;
%     subdata = data(index,:);
%     stu = unique(subdata(:,i_user));
%     for id = 1:length(stu)
%         index = subdata(:,i_user)==stu(id);
%         if sum(data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829, 1137670,1134188]))==6
%             subcorrect =  subdata(index,[i_cor]);
%             if sum(subcorrect(end-2:end))==3
%                 index2=find(data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829]) & data(:,i_subsec)==subsec+1);
%                 tmp  =data(index2(1),:);
%         [ptable,ttable, tgoodtable,tbadtable]=pattern([subdata(index,[i_cor,i_dur]);tmp(:,[i_cor,i_dur])],ptable,ttable, tgoodtable,tbadtable);
%             end
%         else
%             dropout = dropout+1;
%         end
%     end
% end
% 
% sta_time=[];
% k = 1.5;
% for id = 1:4
%     data_time = ttable{id};
%     cutline = prctile(data_time,[25,50,75]);
%     lower = cutline(1)-k*(cutline(3)-cutline(1));
%     upper = cutline(3)+k*(cutline(3)-cutline(1));
%     index = data_time>lower & data_time<upper;
%     sta_time = [sta_time;median(ttable{id}),mean(data_time(index)), std(data_time(index)),mean(ttable{id}),std(ttable{id})];
% end
% sta_time = sta_time';
% 
% sta_goodtime=[];
% k = 1.5;
% for id = 1:4
%     data_time = tgoodtable{id};
%     cutline = prctile(data_time,[25,50,75]);
%     lower = cutline(1)-k*(cutline(3)-cutline(1));
%     upper = cutline(3)+k*(cutline(3)-cutline(1));
%     index = data_time>lower & data_time<upper;
%     sta_goodtime = [sta_goodtime;median(tgoodtable{id}),mean(data_time(index)), std(data_time(index)),mean(tgoodtable{id}),std(tgoodtable{id})];
% end
% sta_goodtime = sta_goodtime';


%% Get statistics2
% each row of ptable represents
% 1.# of students who has done until this opptunity
% 2. #of correct
% 3. # of 3 correct in a row immediately next
ptable = zeros(5,2);
ptable_complete = zeros(5,2);
ptable_notcom = zeros(1,2);
stable = zeros(1,2);
stable_complete = zeros(1,2);
stable_notcom = zeros(1,2);
for id = 1:2
    ttable{id}=[];
    ttable_complete{id}=[];
    ttable_notcom{id}=[];
end
col=1;
for subsec = [1,7,9,15]
    index = data(:,i_subsec)==subsec;
    subdata = data(index,:);
    stu = unique(subdata(:,i_user));
    for id = 1:length(stu)
        index = subdata(:,i_user)==stu(id);
        [tell,tmp] = findseq(subdata(index,i_cor),3);
        if tell
            ttable{col} = [ttable{col},sum(subdata(index,i_dur))];
            ptable(1,col) = ptable(1,col)+1;
            stable(1,col) = stable(1,col)+nanmean(subdata(index,i_cor));
            index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829]);
            cor_morph = data(index,i_cor);
            if sum(cor_morph)==1
                ptable(2,col) = ptable(2,col)+1;
            else
                if sum(cor_morph)==2
                    ptable(3,col) = ptable(3,col)+1;
                end
            end
            index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[1137670,1134188]);
            cor_trans = data(index,i_cor);
            if cor_trans
                ptable(4,col) = ptable(4,col)+1;
                if sum(cor_morph)==2
                    ptable(5,col) = ptable(5,col)+1;
                end
            end
        else
            if sum(data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id))==3
                ttable_complete{col} = [ttable_complete{col},sum(subdata(index,i_dur))];
                ptable_complete(1,col) = ptable_complete(1,col)+1;
                stable_complete(1,col) = stable_complete(1,col)+nanmean(subdata(index,i_cor));
                index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829]);
                cor_morph = data(index,i_cor);
                if sum(cor_morph)==1
                    ptable_complete(2,col) = ptable_complete(2,col)+1;
                else
                    if sum(cor_morph)==2
                        ptable_complete(3,col) = ptable_complete(3,col)+1;
                    end
                end
                index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[1137670,1134188]);
                cor_trans = data(index,i_cor);
                if cor_trans
                    ptable_complete(4,col) = ptable_complete(4,col)+1;
                    if sum(cor_morph)==2
                        ptable_complete(5,col) = ptable_complete(5,col)+1;
                    end
                end
            else
                ttable_notcom{col} = [ttable_notcom{col},sum(subdata(index,i_dur))];
                ptable_notcom(1,col) = ptable_notcom(1,col)+1;
                stable_notcom(1,col) = stable_notcom(1,col)+nanmean(subdata(index,i_cor));
            end
        end
        
    end
end


col = 2;
for subsec = [3,5,11,13]
    index = data(:,i_subsec)==subsec;
    subdata = data(index,:);
    stu = unique(subdata(:,i_user));
    for id = 1:length(stu)
        index = subdata(:,i_user)==stu(id);
        [tell,tmp] = findseq(subdata(index,i_cor),5);
        if tell
            ttable{col} = [ttable{col},sum(subdata(index,i_dur))];
            ptable(1,col) = ptable(1,col)+1;
            stable(1,col) = stable(1,col)+nanmean(subdata(index,i_cor));
            index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829]);
            cor_morph = data(index,i_cor);
            if sum(cor_morph)==1
                ptable(2,col) = ptable(2,col)+1;
            else
                if sum(cor_morph)==2
                    ptable(3,col) = ptable(3,col)+1;
                end
            end
            index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[1137670,1134188]);
            cor_trans = data(index,i_cor);
            if cor_trans
                ptable(4,col) = ptable(4,col)+1;
                if sum(cor_morph)==2
                    ptable(5,col) = ptable(5,col)+1;
                end
            end
        else
                        if sum(data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id))==3
                ttable_complete{col} = [ttable_complete{col},sum(subdata(index,i_dur))];
                ptable_complete(1,col) = ptable_complete(1,col)+1;
                stable_complete(1,col) = stable_complete(1,col)+nanmean(subdata(index,i_cor));
                index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[403325, 403348,403809,403829]);
                cor_morph = data(index,i_cor);
                if sum(cor_morph)==1
                    ptable_complete(2,col) = ptable_complete(2,col)+1;
                else
                    if sum(cor_morph)==2
                        ptable_complete(3,col) = ptable_complete(3,col)+1;
                    end
                end
                index = data(:,i_subsec)==subsec+1 & data(:,i_user)==stu(id) & ismember(data(:,i_pro),[1137670,1134188]);
                cor_trans = data(index,i_cor);
                if cor_trans
                    ptable_complete(4,col) = ptable_complete(4,col)+1;
                    if sum(cor_morph)==2
                        ptable_complete(5,col) = ptable_complete(5,col)+1;
                    end
                end
            else
                ttable_notcom{col} = [ttable_notcom{col},sum(subdata(index,i_dur))];
                ptable_notcom(1,col) = ptable_notcom(1,col)+1;
                stable_notcom(1,col) = stable_notcom(1,col)+nanmean(subdata(index,i_cor));
            end
        end
    end
end



sta_time=[];
k = 1.5;
for id = 1:2
    data_time = ttable{id};
    cutline = prctile(data_time,[25,50,75]);
    lower = cutline(1)-k*(cutline(3)-cutline(1));
    upper = cutline(3)+k*(cutline(3)-cutline(1));
    index = data_time>lower & data_time<upper;
    sta_time = [sta_time;median(ttable{id}),mean(data_time(index)), std(data_time(index)),mean(ttable{id}),std(ttable{id})];
end
sta_time = sta_time';

sta_time_complete=[];
k = 1.5;
for id = 1:2
    data_time = ttable_complete{id};
    cutline = prctile(data_time,[25,50,75]);
    lower = cutline(1)-k*(cutline(3)-cutline(1));
    upper = cutline(3)+k*(cutline(3)-cutline(1));
    index = data_time>lower & data_time<upper;
    sta_time_complete = [sta_time_complete;median(ttable_complete{id}),mean(data_time(index)), std(data_time(index)),mean(ttable_complete{id}),std(ttable_complete{id})];
end
sta_time_complete = sta_time_complete';


sta_time_notcom=[];
k = 1.5;
for id = 1:2
    data_time = ttable_notcom{id};
    cutline = prctile(data_time,[25,50,75]);
    lower = cutline(1)-k*(cutline(3)-cutline(1));
    upper = cutline(3)+k*(cutline(3)-cutline(1));
    index = data_time>lower & data_time<upper;
    sta_time_notcom = [sta_time_notcom;nanmedian(ttable_notcom{id}),nanmean(data_time(index)), nanstd(data_time(index)),nanmean(ttable_notcom{id}),nanstd(ttable_notcom{id})];
end
sta_time_notcom = sta_time_notcom';





