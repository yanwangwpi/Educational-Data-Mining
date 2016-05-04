clc;
close all;
clear all;

data = csvread('merged part4&5 - use the entire data set''s coefficients.csv',2,0);

data1 = csvread('merged part4&5 - group 1 as test.csv',2,0);
data2 = csvread('merged part4&5 - group 2 as test.csv',2,0);
data3 = csvread('merged part4&5 - group 3 as test.csv',2,0);

i_ord = 1;
i_user = 2;
i_skill = 3;
i_opp = 19;
i_ws = 20;
i_dur = 26;
i_dur_val = 30;
i_pred = 35;
i_group = 28;

%% Combine prediction together
data = sortrows(data,i_ord);
data1 = sortrows(data1,i_ord);
data2 = sortrows(data2,i_ord);
data3 = sortrows(data3,i_ord);

index = data(:,i_group)==1 & data(:,i_ws)==1;
index1 = data1(:,i_group)==1 & data1(:,i_ws)==1;
data(index,i_pred) = data1(index1,i_pred);
if sum(abs(data(index,i_ord)-data1(index1,i_ord)))~=0
    disp('error')
end
index = data(:,i_group)==1 & data(:,i_ws)==0;
index1 = data1(:,i_group)==1 & data1(:,i_ws)==0;
data(index,i_pred) = data1(index1,i_pred);
if sum(abs(data(index,i_ord)-data1(index1,i_ord)))~=0
    disp('error')
end

index = data(:,i_group)==2 & data(:,i_ws)==1;
index2 = data2(:,i_group)==2 & data2(:,i_ws)==1;
data(index,i_pred) = data2(index2,i_pred);
if sum(abs(data(index,i_ord)-data2(index2,i_ord)))~=0
    disp('error')
end
index = data(:,i_group)==2 & data(:,i_ws)==0;
index2 = data2(:,i_group)==2 & data2(:,i_ws)==0;
data(index,i_pred) = data2(index2,i_pred);
if sum(abs(data(index,i_ord)-data2(index2,i_ord)))~=0
    disp('error')
end

index = data(:,i_group)==3 & data(:,i_ws)==1;
index3 = data3(:,i_group)==3 & data3(:,i_ws)==1;
data(index,i_pred) = data3(index3,i_pred);
if sum(abs(data(index,i_ord)-data3(index3,i_ord)))~=0
    disp('error')
end
index = data(:,i_group)==3 & data(:,i_ws)==0;
index3 = data3(:,i_group)==3 & data3(:,i_ws)==0;
data(index,i_pred) = data3(index3,i_pred);
if sum(abs(data(index,i_ord)-data3(index3,i_ord)))~=0
    disp('error')
end

index = data(:,i_pred)==0;
data(index,i_pred)=nan;

dataorin = data;

index = data(:,i_opp)<=9;
data = data(index,:);

%% # of student-skill pairs in each category
cat = [];
index = data(:,i_ws)==1;
cat = [cat,length(unique(data(index,[i_user,i_skill]),'rows'))];
index = data(:,i_ws)==0;
cat = [cat,length(unique(data(index,[i_user,i_skill]),'rows'))];
index = data(:,i_ws)==-1;
cat = [cat,length(unique(data(index,[i_user,i_skill]),'rows'))];

%% # of student-skill pairs in each category
cat_ws = [];
cat_master = [];
cat_indeter = [];
for id = 0:9
index = data(:,i_ws)==1 & data(:,i_opp)==id;
cat_ws = [cat_ws,sum(index)];
index = data(:,i_ws)==0 & data(:,i_opp)==id;
cat_master = [cat_master,sum(index)];
index = data(:,i_ws)==-1 & data(:,i_opp)==id;
cat_indeter = [cat_indeter,sum(index)];
end
figure;
% plot([1:10],cat_ws./(cat_ws+cat_master));
bar([1:10],[cat_ws',cat_master']);
xlabel('Practice Opportunity (PO)')
title('Number of WB and Mastery in determinate cases');
grid on;
%% confusion table
confusion = zeros(2,2);
for id =1:3
index = data(:,i_group)==id;
subdata = data(index,:);
mm = sum(subdata(:,i_ws)==0 & subdata(:,i_pred)>=0.5);
mw = sum(subdata(:,i_ws)==0 & subdata(:,i_pred)<0.5);
wm = sum(subdata(:,i_ws)==1 & subdata(:,i_pred)>=0.5);
ww = sum(subdata(:,i_ws)==1 & subdata(:,i_pred)<0.5);

confusion = confusion+[mm mw; wm ww];
end
confusion = confusion./3;
%% distribution of time
index = data(:,i_dur_val)==1;
valdata = data(index,:);
index = valdata(:,i_ws)==0;
mtime = sum(valdata(index,i_dur));
index = valdata(:,i_ws)==1;
wtime = sum(valdata(index,i_dur));
index= valdata(:,i_ws)==-1;
mtimeadd = sum(valdata(index,i_dur).*valdata(index,i_pred));
wtimeadd = sum(valdata(index,i_dur).*(1-valdata(index,i_pred)));
mtimetol = (mtime+mtimeadd)/3600;
wtimetol = (wtime+wtimeadd)/3600;


%% Precision and Recall WS
index = data(:,i_ws)==1 |data(:,i_ws)==0 ;
sub = data(index,:);

PR =[];
for id = 0:9
    index = sub(:,i_opp) ==id;
    subdata = sub(index,:);
    wpred = sum(subdata(:,i_pred)<0.5);
    wpredtrue = sum(subdata(:,i_pred)<0.5 & subdata(:,i_ws)==1);
    wtrue = sum(subdata(:,i_ws)==1);
    PR = [PR;wpredtrue/wpred,wpredtrue/wtrue];
end


figure;
plot([1:10],PR(:,1));
hold on;
plot([1:10],PR(:,2),'r');
xlabel('Practice Opportunity (PO)')
title('Precision and Recall of WS Estimation')
grid on;

%% Precision and Recall MS
index = data(:,i_ws)==1 |data(:,i_ws)==0 ;
sub = data(index,:);

PRM =[];
for id = 0:9
    index = sub(:,i_opp) ==id;
    subdata = sub(index,:);
    mpred = sum(subdata(:,i_pred)>=0.5);
    mpredtrue = sum(subdata(:,i_pred)>=0.5 & subdata(:,i_ws)==0);
    mtrue = sum(subdata(:,i_ws)==0);
    PRM = [PRM;mpredtrue/mpred,mpredtrue/mtrue];
end


figure;
plot([1:10],PRM(:,1));
hold on;
plot([1:10],PRM(:,2),'r');
xlabel('Practice Opportunity (PO)')
title('Precision and Recall of Mastery Estimation')
grid on;

%% Ratio of Precision and Recall
figure;
plot([1:10],PR(:,1)./PR(:,2))
hold on;
plot([1:10],PRM(:,1)./PRM(:,2))
xlabel('Practice Opportunity (PO)')
title('Ratio of Precision and Recall')

%% Time consumption distribution
wtimeopp = [];
mtimeopp = [];
gtimeopp =[];
index = data(:,i_dur_val)==1;
valdata = data(index,:);
for id = 0:9
    index = valdata(:,i_opp)==id & valdata(:,i_ws)==1;
    wtimeopp = [wtimeopp;mean(valdata(index,i_dur))];
    index = valdata(:,i_opp)==id & valdata(:,i_ws)==0;
    mtimeopp = [mtimeopp;mean(valdata(index,i_dur))];
    index = valdata(:,i_opp)==id & valdata(:,i_ws)==-1;
    gtimeopp = [gtimeopp;mean(valdata(index,i_dur))];
end

figure;
hold on;
% plot([1:10],wtimeopp,'r');
% plot([1:10],mtimeopp,'b');
% plot([1:10],gtimeopp,'k');
bar([1:10],[gtimeopp,mtimeopp,wtimeopp]);
xlabel('Practice Opportunity (PO)');
ylabel('second');
title('Average Time Spent on a Problem');


%% Mastery Change
% mstpess =[];
% mstop=[];
% mstest=[];
% for id = 0:9
%     index = data(:,i_opp)==id & data(:,i_ws)==0;
%     mstpess = [mstpess,sum(index)];
%     
%     index = data(:,i_opp)==id & (data(:,i_ws)==0 |data(:,i_ws)==-1);
%     mstop = [mstop,sum(index)];
%     
%     index = data(:,i_opp)==id & (data(:,i_ws)==0 |(data(:,i_ws)==-1 & data(:,i_pred)>=0.5));
%     mstest = [mstest,sum(index)];
% end

% figure;
% plot([1:10],[diff(mstpess),mstpess(end)]);
% hold on;
% plot([1:10],[diff(mstop),mstop(end)],'r');
% plot([1:10],[diff(mstest),mstest(end)],'k');


mspess =zeros(10,1);
msop=zeros(10,1);
msest=zeros(10,1);
indeter = zeros(10,1);
tol=0;
skill = unique(data(:,i_skill));
for id = 1:length(skill)
    index=  data(:,i_skill)==skill(id);
    sub = data(index,:);
    user = unique(sub(:,i_user));
    for idu = 1:length(user)
        tol = tol+1;
        index = sub(:,i_user)==user(idu);
        subsub = sub(index,:);
        [opp,I] = max(subsub(:,i_opp));
        if opp==0 | opp==1
            disp('eror');
        end
        opp = opp+1;
        ws = subsub(I,i_ws);
        if ws==0
        mspess(opp) = mspess(opp)+1;
        msop(opp) = msop(opp)+1;
        end
        if ws==-1
            indeter(opp) = indeter(opp)+1;
            if subsub(I,i_pred)>=0.5
                msest(opp) = msest(opp)+1;
            end
        end
    end
end


modifymsest = msest.*PRM(:,1)./PRM(:,2);
tolms = msest+mspess;
modifytolms = modifymsest+mspess;

% MS change
figure;

hold on;
plot([1:10],cumsum(msop+indeter)/tol,'r');
plot([1:10],cumsum(tolms)/tol,'k');
plot([1:10],cumsum(modifytolms)/tol,'g')
plot([1:10],cumsum(mspess)/tol);
xlabel('Practice Opportunity (PO)');
ylabel('Percent of students having mastered the skills');
% Distribution of WS in each PO
figure;
bar([1:10],indeter);
xlabel('Category by PO');
ylabel('Number of student-skill pairs')
title('Distribution of Maximum PO in Indeterminate Group')

% Ratio to be estimated
figure;
% plot([1:10],msest./indeter);
% hold on;
% plot([1:10],modifymsest./indeter,'r');
bar([1:10],[msest./indeter,modifymsest./indeter]);
xlabel('Category by PO');
ylabel('Percent of student-skill pairs estimated as mastery')
title('Ratio Estimated as Mastery')

            
%% Time distribution
timeest=zeros(10,1);
timeindeter = zeros(10,1);

index = data(:,i_ws)==-1;
wsdata = data(index,:);
skill = unique(wsdata(:,i_skill));
for id = 1:length(skill)
    index=  wsdata(:,i_skill)==skill(id);
    sub = wsdata(index,:);
    user = unique(sub(:,i_user));
    for idu = 1:length(user)
        index = sub(:,i_user)==user(idu);
        subsub = sub(index,:);
        [opp,I] = max(subsub(:,i_opp));
        opp = opp+1;
        if sum(subsub(:,i_dur_val))==size(subsub,1)
            timeindeter(opp) = timeindeter(opp)+sum(subsub(:,i_dur));
            timeest(opp) = timeest(opp)+sum(subsub(:,i_dur))*(1-subsub(I,i_pred));
        end
    end
end

modifytimeest = timeest.*PR(:,1)./PR(:,2);


% Time change
% Ratio to be estimated
figure;
% plot([1:10],timeest./timeindeter);
% hold on;
% plot([1:10],modifytimeest./timeindeter,'r');
bar([1:10],[timeest./timeindeter,modifytimeest./timeindeter]);
xlabel('Category by PO');
ylabel('Percent of time estimated as WS')

timetable=[wtime;wtime+sum(timeest);wtime+sum(modifytimeest); wtime+sum(timeindeter)];
toltime = wtime+mtime+sum(timeindeter)
timetable = [toltime-timetable,timetable];
timetable = timetable';


%% Time distribution--Simple version
timeest=zeros(10,1);
timeindeter = zeros(10,1);

index = data(:,i_ws)==-1;
wsdata = data(index,:);
skill = unique(wsdata(:,i_skill));
for id = 1:length(skill)
    index=  wsdata(:,i_skill)==skill(id);
    sub = wsdata(index,:);
    user = unique(sub(:,i_user));
    for idu = 1:length(user)
        index = sub(:,i_user)==user(idu);
        subsub = sub(index,:);
        [opp,I] = max(subsub(:,i_opp));
        opp = opp+1;
        if sum(subsub(:,i_dur_val))==size(subsub,1)
            timeindeter(opp) = timeindeter(opp)+sum(subsub(:,i_dur));
            timeest(opp) = timeest(opp)+sum(subsub(:,i_dur))*(1-subsub(I,i_pred));
        end
    end
end
timeest = (indeter-msest)./indeter.*timeindeter;
modifytimeest = timeest.*PR(:,1)./PR(:,2);


% Time change
% Ratio to be estimated
figure;
% plot([1:10],timeest./timeindeter);
% hold on;
% plot([1:10],modifytimeest./timeindeter,'r');
bar([1:10],[timeest./timeindeter,modifytimeest./timeindeter]);
xlabel('Category by PO');
ylabel('Percent of time estimated as WS')

timetable=[wtime;wtime+sum(timeest);wtime+sum(modifytimeest); wtime+sum(timeindeter)];
toltime = wtime+mtime+sum(timeindeter)
timetable = [toltime-timetable,timetable];
timetable = timetable';



