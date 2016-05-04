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

% [data, text, alldata] = xlsread('PSASXWU.xlsx');
% 
% i_user = 3;
% i_cor = 7;
% i_pro = 5;
% i_ord = 1;
% i_start = 22;
% i_end = 23;
% i_dur = 24;
% problem_id 1134182, 1134189, 1134191, 1134192 represents 4 conditions


[data, text, alldata] = xlsread('Trimmed-N-CCR order of op.xlsx','Sheet2');

i_user = 1;
i_cor = 2;
i_pro = 4;
i_ord = 3;
i_start = 5;
i_end = 6;
i_dur = 7;
i_condition = 8;
i_complete = 10;
% Problem number 231085, 746310, 746316, 746317 
% Transfer number 745796, 746307, 746308, 746309 
alldata = alldata(2:end,:);
%% Transform data, so as to add conditions
N = size(data,1);

index = data(:,i_pro) == 231085;
stu{1} = data(index,i_user);

index = data(:,i_pro) == 746310;
stu{2} = data(index,i_user);

index = data(:,i_pro) == 746316;
stu{3} = data(index,i_user);

index = data(:,i_pro) == 746317;
stu{4} = data(index,i_user);

% data = [data, NaN(N,4)];

for stuId = 1:4
    index = ismember(data(:,i_user),stu{stuId});
    data(index, i_condition) = ones(sum(index),1)*stuId;
    % transform time to duration
    time_raw = alldata(index,[i_start,i_end]);
    dur = [];
    for id = 1:size(time_raw,1)
        t = textscan(time_raw{id,1}, '"%f-%f-%f %f:%f:%f"');
        start_t = datenum(t{1},t{2},t{3}, t{4},t{5},t{6});
        t = textscan(time_raw{id,2}, '"%f-%f-%f %f:%f:%f"');
        end_t = datenum(t{1},t{2},t{3}, t{4},t{5},t{6});
        if size(end_t,1)==0
            dur = [dur;nan];
        else
            dur = [dur;end_t-start_t];
        end
    end
    data(index, i_dur) = dur;
end

data(:, i_dur) = data(:, i_dur)*24*3600;


%% get rid of intro questions, and divide into sections
index = ~ismember(data(:,i_pro), [745796, 746307, 746308, 746309]);
data_new = data(index,:);

numAvg = [];
numStd = [];
num = [];
for stuId = 1:4
    numEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        numEach = [numEach; sum(index)];
    end
    numAvg = [numAvg;nanmean(numEach)];
    numStd = [numStd; nanstd(numEach)];
    num = [num, length(numEach)];
end

numAvgFinish = [];
numStdFinish = [];
numFinish = [];
for stuId = 1:4
    numEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if size(oneStuData,1)>stuId &&(all(oneStuData(end-stuId:end,i_cor)))
            numEach = [numEach; sum(index)];
        end
    end
    numAvgFinish = [numAvgFinish;nanmean(numEach)];
    numStdFinish = [numStdFinish; nanstd(numEach)];
    numFinish = [numFinish, length(numEach)];
end


numAvgComplete = [];
numStdComplete = [];
numComplete = [];
for stuId = 1:4
    numEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if oneStuData(1,i_complete)
            numEach = [numEach; sum(index)];
        end
    end
    numAvgComplete = [numAvgComplete;nanmean(numEach)];
    numStdComplete = [numStdComplete; nanstd(numEach)];
    numComplete = [numComplete, length(numEach)];
end

timeAvg = [];
timeStd = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        timeEach = [timeEach; sum(data_new(index,i_dur))];
    end
    timeAvg = [timeAvg;nanmean(timeEach)];
    timeStd = [timeStd; nanstd(timeEach)];
end

timeAvgFinish = [];
timeStdFinish = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if size(oneStuData,1)>stuId &&(all(oneStuData(end-stuId:end,i_cor)))
            timeEach = [timeEach; sum(data_new(index,i_dur))];
        end
    end
    timeAvgFinish = [timeAvgFinish;nanmean(timeEach)];
    timeStdFinish = [timeStdFinish; nanstd(timeEach)];
end

timeAvgComplete = [];
timeStdComplete = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if oneStuData(1,i_complete)
            timeEach = [timeEach; sum(data_new(index,i_dur))];
        end
    end
    timeAvgComplete = [timeAvgComplete;nanmean(timeEach)];
    timeStdComplete = [timeStdComplete; nanstd(timeEach)];
end
        
k=1.5;
dur = data_new(:,i_dur);
cutline = prctile(dur,[25,50,75]);
lower = cutline(1)-k*(cutline(3)-cutline(1));
upper = cutline(3)+k*(cutline(3)-cutline(1));
index = dur<lower;
data_new(index,i_dur)=lower;
index = dur>upper;
data_new(index,i_dur)=upper;


timeAvgNoOutlier = [];
timeStdNoOutlier = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        timeEach = [timeEach; sum(data_new(index,i_dur))];
    end
    timeAvgNoOutlier = [timeAvgNoOutlier;nanmean(timeEach)];
    timeStdNoOutlier = [timeStdNoOutlier; nanstd(timeEach)];
end


timeAvgNoOutlierFinish = [];
timeStdNoOutlierFinish = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if size(oneStuData,1)>stuId &&(all(oneStuData(end-stuId:end,i_cor)))
            timeEach = [timeEach; sum(data_new(index,i_dur))];
        end
    end
    timeAvgNoOutlierFinish = [timeAvgNoOutlierFinish;nanmean(timeEach)];
    timeStdNoOutlierFinish = [timeStdNoOutlierFinish; nanstd(timeEach)];
end

timeAvgNoOutlierComplete = [];
timeStdNoOutlierComplete = [];
for stuId = 1:4
    timeEach = [];
    stuThisGroup = stu{stuId};
    for id = 1:length(stuThisGroup)
        index = data_new(:,i_user)==stuThisGroup(id);
        oneStuData = data_new(index,:);
        oneStuData = sortrows(oneStuData, i_ord);
        if oneStuData(1,i_complete)
            timeEach = [timeEach; sum(data_new(index,i_dur))];
        end
    end
    timeAvgNoOutlierComplete = [timeAvgNoOutlierComplete;nanmean(timeEach)];
    timeStdNoOutlierComplete = [timeStdNoOutlierComplete; nanstd(timeEach)];
end






