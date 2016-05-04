% This file is used to tell difference of groups through multivariate 

clc;
clear all;
% close all;

data = xlsread('InterleavingBlockingData.xlsx');

group = data(1:60,:);
inter = data(61:end,:);

% group count, prior, correct, FA, hint count, bottom, attempt count, time,
% overlap time

ii_count = 1;
ii_prior = 2;
ii_correct = 3;
ii_fa = 7;
ii_hint = 11;
ii_bot = 15;
ii_att = 19;
ii_time = 23;


% %put students into low and high level
mix = [group;inter];
cut = median(mix(:,2));
index = mix(:,2)<cut;
low = mix(index,:);
index = mix(:,2)>=cut;
high = mix(index,:);

mix = [group;inter];
cut = median(group(:,2));
index = group(:,2)<cut;
low = group(index,:);
cut = median(inter(:,2));
index = inter(:,2)<cut;
high = inter(index,:);

% calculate p value for correctness
% calculate partial credit

perct_tol=[];
figure;

for item = 3
partial = 1-low(:,ii_hint:ii_hint+item)*0.3-(low(:,ii_att:ii_att+item)-1)*0.1;%
partial = partial_credit(low(:,ii_correct:ii_correct+item),low(:,ii_hint:ii_hint+item), ones(size(low(:,ii_hint:ii_hint+item)))*3, (low(:,ii_att:ii_att+item)));
index = partial<0;
partial(index)=0;
group_data = mean(partial,2);%low(:,cor:cor+3)+
% partial  = partial_credit(high(:,ii_hint:ii_hint+item), high(:,ii_hall:ii_hall+item), (high(:,ii_att:ii_att+item)),1/ratio_hint,1/ratio_att,1);
partial = 1-high(:,ii_hint:ii_hint+item)*0.3-(high(:,ii_att:ii_att+item)-1)*0.1;%
partial = partial_credit(high(:,ii_correct:ii_correct+item),high(:,ii_hint:ii_hint+item), ones(size(high(:,ii_hint:ii_hint+item)))*3, (high(:,ii_att:ii_att+item)));

index = partial<0;
partial(index)=0;
inter_data = mean(partial,2);%high(:,cor:cor+3)+

group_data_b = mean(low(:,ii_correct:ii_correct+item),2);
inter_data_b = mean(high(:,ii_correct:ii_correct+item),2);

% group_data_m = [mean(low(:,ii_correct:ii_correct+item),2), mean(low(:,ii_hint:ii_hint+item),2),...
%     mean(low(:,ii_att:ii_att+item),2)-1];
% inter_data_m = [mean(high(:,ii_correct:ii_correct+item),2), mean(high(:,ii_hint:ii_hint+item),2),...
%     mean(high(:,ii_att:ii_att+item),2)-1];

groupN  =size(group_data,1);
interN = size(inter_data,1);



%resample without replacement
N = 250;min(groupN,interN);
NS = 5000;

step = -5;
ending = 5;

perct = [];
perctA = [];
perctM = [];
for k = N:step:ending
    ptmpA=[];
    ptmp=[];
    ptmpM=[];
    num=0;
for id = 1:NS
groupI = randsample(groupN,k,'true');
interI = randsample(interN,k,'true');
% ANOVAL
% X = [group_data(groupI),inter_data(interI)];
[h,p] = ttest2(group_data(groupI),inter_data(interI));%,'Vartype','unequal'

% X = [group_data(groupI,:),inter_data(interI,:)];
% [pA] = anova1(X,[],'off');
% p= anova1(X,[],'off');
ptmp = [ptmp,p];
[h,pA] = ttest2(group_data_b(groupI),inter_data_b(interI));
ptmpA = [ptmpA,pA];

% % MANOVAL
% X = [group_data_m(groupI,:);inter_data_m(interI,:)];
% Group = [ones(k,1); ones(k,1)*2];
% try
% [d,p] = manova1(X,Group);
% ptmpM = [ptmpM,p(1)];
% catch
%     num = num+1;
% end

end
% perctM=[perctM,sum(ptmpM<0.05)/(NS-num)];
perct=[perct,sum(ptmp<0.05)/NS];
perctA=[perctA,sum(ptmpA<0.05)/NS];
end

% errorbar(N:-2:5,mean(pval,2),std(pval,0,2),'r')
% subplot(1,2,1);
figure;
hold on;
plot(N:step:ending,perct*100,'r');
plot(N:step:ending,perctA*100,'.-');
% plot(N:step:ending,perctM,'k');

end
grid on
xlabel('Number of students');
ylabel('Percent of experiments with p value < 0.05');
title('High performance VS Low performance')


grid on
xlabel('Number of students');
ylabel('Percent of experiments with p value < 0.05');
title('Interleaving VS Blocking--Low performing')



item = 3;
sta =[];
tmpl =mean(mean(low(:,ii_correct:ii_correct+item),2));
tmph =mean(mean(high(:,ii_correct:ii_correct+item),2));
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_correct:ii_correct+item),2));
tmph =std(mean(high(:,ii_correct:ii_correct+item),2));
sta = [sta; tmpl,tmph];

tmpl =mean(mean(low(:,ii_hint:ii_hint+item),2));
tmph =mean(mean(high(:,ii_hint:ii_hint+item),2));
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_hint:ii_hint+item),2));
tmph =std(mean(high(:,ii_hint:ii_hint+item),2));
sta = [sta; tmpl,tmph];

tmpl =mean(mean(low(:,ii_att:ii_att+item),2));
tmph =mean(mean(high(:,ii_att:ii_att+item),2));
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_att:ii_att+item),2));
tmph =std(mean(high(:,ii_att:ii_att+item),2));
sta = [sta; tmpl,tmph];
sta = sta';
