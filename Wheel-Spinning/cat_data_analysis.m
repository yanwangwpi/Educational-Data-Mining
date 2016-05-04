clc;
close all;
clear all;

data = csvread('use the model of cal prediction.csv',2,0);

i_ord = 1;
i_user = 2;
i_skill = 3;
i_opp = 17;
i_ws = 21;
i_dur = 18;
i_dur_val = 19;
i_pred = 26;

cat =15;

%% Combine prediction together
data = sortrows(data,i_ord);


index = data(:,i_pred)==0;
data(index,i_pred)=nan;

dataorin = data;

index = data(:,i_opp)<=14;
data = data(index,:);
%% confusion table
confusion = zeros(2,2);

subdata = data;
mm = sum(subdata(:,i_ws)==0 & subdata(:,i_pred)>=0.5);
mw = sum(subdata(:,i_ws)==0 & subdata(:,i_pred)<0.5);
wm = sum(subdata(:,i_ws)==1 & subdata(:,i_pred)>=0.5);
ww = sum(subdata(:,i_ws)==1 & subdata(:,i_pred)<0.5);

confusion = confusion+[mm mw; wm ww];

confusion = confusion;
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
for id = 0:cat-1
    index = sub(:,i_opp) ==id;
    subdata = sub(index,:);
    wpred = sum(subdata(:,i_pred)<0.5);
    wpredtrue = sum(subdata(:,i_pred)<0.5 & subdata(:,i_ws)==1);
    wtrue = sum(subdata(:,i_ws)==1);
    PR = [PR;wpredtrue/wpred,wpredtrue/wtrue];
end


figure;
plot([1:cat],PR(:,1));
hold on;
plot([1:cat],PR(:,2),'r');
xlabel('Practice Opportunity (PO)')
title('Precision and Recall of WS Estimation')
grid on;

%% Precision and Recall MS
index = data(:,i_ws)==1 |data(:,i_ws)==0 ;
sub = data(index,:);

PRM =[];
for id = 0:cat-1
    index = sub(:,i_opp) ==id;
    subdata = sub(index,:);
    mpred = sum(subdata(:,i_pred)>=0.5);
    mpredtrue = sum(subdata(:,i_pred)>=0.5 & subdata(:,i_ws)==0);
    mtrue = sum(subdata(:,i_ws)==0);
    PRM = [PRM;mpredtrue/mpred,mpredtrue/mtrue];
end


figure;
plot([1:cat],PRM(:,1));
hold on;
plot([1:cat],PRM(:,2),'r');
xlabel('Practice Opportunity (PO)')
title('Precision and Recall of Mastery Estimation')
grid on;

%% Time consumption distribution
wtimeopp = [];
mtimeopp = [];
gtimeopp =[];
for id = 0:cat-1
    index = data(:,i_opp)==id & data(:,i_ws)==1;
    wtimeopp = [wtimeopp;mean(data(index,i_dur))];
    index = data(:,i_opp)==id & data(:,i_ws)==0;
    mtimeopp = [mtimeopp;mean(data(index,i_dur))];
    index = data(:,i_opp)==id;
    gtimeopp = [gtimeopp;mean(data(index,i_dur))];
end

figure;
hold on;
% plot([1:10],wtimeopp,'r');
% plot([1:10],mtimeopp,'b');
% plot([1:10],gtimeopp,'k');
bar([1:cat],[gtimeopp,mtimeopp,wtimeopp]);
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


mspess =zeros(cat,1);
msop=zeros(cat,1);
msest=zeros(cat,1);
indeter = zeros(cat,1);
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
plot([1:cat],cumsum(mspess)/tol);
hold on;
plot([1:cat],cumsum(msop+indeter)/tol,'r');
plot([1:cat],cumsum(tolms)/tol,'k');
plot([1:cat],cumsum(modifytolms)/tol,'g');
xlabel('Practice Opportunity (PO)');
ylabel('Percent of students having mastered the skills');
% Distribution of WS in each PO
figure;
bar([1:cat],indeter);
xlabel('Category by PO');
ylabel('Number of student-skill pairs')
title('Distribution of Maximum PO in Indeterminate Group')

% Ratio to be estimated
figure;
% plot([1:10],msest./indeter);
% hold on;
% plot([1:10],modifymsest./indeter,'r');
bar([1:cat],[msest./indeter,modifymsest./indeter]);
xlabel('Category by PO');
ylabel('Percent of student-skill pairs estimated as mastery')
title('Ratio Estimated as Mastery')

            
%% Time distribution
timeest=zeros(10,1);
timeindeter = zeros(10,1);
tol=0;
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
tol=0;
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



