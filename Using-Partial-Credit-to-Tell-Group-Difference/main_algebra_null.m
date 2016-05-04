% This file is used to draw curve data points VS p-value

clc;
clear all;
% close all;

load algebra_data;


%        data_new = [data_new;skills(id_seq),students(id_stu),num,...
%             stu_skill_prior_num(index,4),...
%             stu_skill_prior_num(index,3),...
%             subsubdata(:,i_correct)',blank,...
%             subsubdata(:,i_hint)',blank, ...
%             subsubdata(:,i_att)',blank];

max_num = 15;
ii_seq = 1;
ii_stu = 2;
ii_num = 3;
ii_prior_count = 4;
ii_prior_suc = 5;
ii_correct = 6;
ii_hint = ii_correct+max_num;
ii_att = ii_hint+max_num;

skills = [15;10;41;31;11;45];
maxes = [800,400,1600,200,400,200];

% perct_tol=[];
item = 2;
num_all=[];
sta_all=[];
for id_skill = 1:6
    data = data_new(data_new(:,ii_seq)==skills(id_skill),:);
    
    %% select data
    
    index = data(:,ii_num)>=3 & data(:,ii_prior_count)>=100;
    data = data(index,:);
    length(unique(data(:,ii_stu)))
    mean(nanmean(data(:,ii_correct:ii_correct+item),2))
    
    %  partition into 2 level groups
    cutline = prctile(data(:,ii_prior_suc),[50]);
    index = data(:,ii_prior_suc)<cutline(1);
    low = data;
    index = data(:,ii_prior_suc)>=cutline(1);
    high = data;
    
%     %  partition into 2 level groups
%     cutline = prctile(data(:,ii_prior_suc),[80 90]);
%     index = data(:,ii_prior_suc)<cutline(2) & data(:,ii_prior_suc)>=cutline(1);
%     low = data(index,:);
%     index = data(:,ii_prior_suc)>=cutline(2);
%     high = data(index,:);
    
    num_all = [num_all;size(data,1)];
    
    %%
    % Partial 1
    partial  = partial_credit(low(:,ii_correct:ii_correct+item),low(:,ii_hint:ii_hint+item), ones(size(low,1),item+1)*3, (low(:,ii_att:ii_att+item)));
    % partial = 1-low(:,ii_hint:ii_hint+item)./low(:,ii_hall:ii_hall+item)-(low(:,ii_att:ii_att+item)-1)*0.3;%
    index = partial<0;
    partial(index)=0;
    low_data = nanmean(partial,2);%low(:,cor:cor+3)+
    partial  = partial_credit(high(:,ii_correct:ii_correct+item),high(:,ii_hint:ii_hint+item),ones(size(high,1),item+1)*3, (high(:,ii_att:ii_att+item)));
    % partial = 1-high(:,ii_hint:ii_hint+item)./high(:,ii_hall:ii_hall+item)-(high(:,ii_att:ii_att+item)-1)*0.3;%
    index = partial<0;
    partial(index)=0;
    high_data = nanmean(partial,2);%high(:,cor:cor+3)+
    
    % bianry
    low_data_b = nanmean(low(:,ii_correct:ii_correct+item),2);
    high_data_b = nanmean(high(:,ii_correct:ii_correct+item),2);
    
    % % MANOVA
    % low_data_m = [mean(low(:,ii_correct:ii_correct+item),2), mean(low(:,ii_hint:ii_hint+item)./low(:,ii_hall:ii_hall+item),2),...
    %     mean(low(:,ii_att:ii_att+item),2)-1];
    % high_data_m = [mean(high(:,ii_correct:ii_correct+item),2), mean(high(:,ii_hint:ii_hint+item)./high(:,ii_hall:ii_hall+item),2),...
    %     mean(high(:,ii_att:ii_att+item),2)-1];
    
    %resample without replacement
    groupN  =size(low_data,1);
    interN = size(high_data,1);
    N = maxes(id_skill);
    NS = 5000;
    step = -5;
    ending = 10;
    pval=[];
    perct = [];
    perctb = [];
    perctm = [];
    for k = N:step:ending
        ptmp=[];
        num = 0;
        ptmpb=[];
        numb = 0;
        ptmpm=[];
        numm = 0;
        for id = 1:NS
            groupI = randsample(groupN,k,'true');
            interI = randsample(interN,k,'true');
            
            % ANOVAL
            % X = [low_data(groupI),high_data(interI)];
            % % [h,p] = ttest2(group_data(groupI),inter_data(interI));%,'Vartype','unequal'
            % p= anova1(X,[],'off');
            
            % ANOVAL of partial
            try
                % p = anova1(X,[],'off');
                
                [h,p] = ttest2(low_data(groupI,:),high_data(interI,:));
                ptmp = [ptmp,p(1)];
            catch
                num = num+1;
            end
            
            
            % ANOVAL of binary
            try
                % p = anova1(X,[],'off');
                [h,p] = ttest2(low_data_b(groupI,:),high_data_b(interI,:));
                ptmpb = [ptmpb,p(1)];
            catch
                numb = numb+1;
            end
            
            %                 % MANOVA
            %                 X = [low_data_m(groupI,:);high_data_m(interI,:)];
            %                 Group = [ones(k,1); ones(k,1)*2];
            %                 try
            %                     [d,p] = manova1(X,Group);
            %                     ptmpm = [ptmpm,p(1)];
            %                 catch
            %                     numm = numm+1;
            %                 end
            %
            % [h,p] = ttest2(group_low_data(groupI),inter_low_data(interI));
        end
        perct=[perct,sum(ptmp<0.05)/(NS-num)];
        perctb=[perctb,sum(ptmpb<0.05)/(NS-numb)];
        %             perctm=[perctm,sum(ptmpm<0.05)/(NS-numm)];
    end
    % hold on;
    % errorbar(N:-2:5,mean(pval,2),std(pval,0,2),'r')
    perct_tol{id_skill} = [perct;perctb];
    figure;
    hold on;
    plot(N:step:ending,perct,'r');
    plot(N:step:ending,perctb);
%     plot(N:step:ending,perctm,'k');
    



% grid on
% xlabel('# of subjects');
% ylabel('Percentage of resamples with p-value<=0.05');
% title('Resample with replacement 5000 times')

item = 2;
sta =[];
tmpl =mean(mean(low(:,ii_correct:ii_correct+item),2));
tmph =mean(mean(high(:,ii_correct:ii_correct+item),2));
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_correct:ii_correct+item),2));
tmph =std(mean(high(:,ii_correct:ii_correct+item),2));
sta = [sta; tmpl,tmph];

tmpl =mean(mean(low(:,ii_hint:ii_hint+item),2));%./low(:,ii_hall:ii_hall+item)
tmph =mean(mean(high(:,ii_hint:ii_hint+item),2));%./high(:,ii_hall:ii_hall+item)
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_hint:ii_hint+item),2));%./low(:,ii_hall:ii_hall+item)
tmph =std(mean(high(:,ii_hint:ii_hint+item),2));%./high(:,ii_hall:ii_hall+item)
sta = [sta; tmpl,tmph];

tmpl =mean(mean(low(:,ii_att:ii_att+item),2));
tmph =mean(mean(high(:,ii_att:ii_att+item),2));
sta = [sta; tmpl,tmph];
tmpl =std(mean(low(:,ii_att:ii_att+item),2));
tmph =std(mean(high(:,ii_att:ii_att+item),2));
sta = [sta; tmpl,tmph];
sta = sta';
sta_all = [sta_all;sta];
end

save perct_tol perct_tol


skillname = {'SkillRule: Consolidate vars, no coeff; CLT','SkillRule: Consolidate vars with coeff; CLT',...
    'Labelling the axes','Find X, positive slope',...
    'combine-like-terms-sp','Write expression, negative slope',...
    };


figure;
for id = 1:6
    subplot(3,2,7-id);
    perct = perct_tol{id};
    plot(maxes(id):step:ending,perct(1,:)*100,'r');hold on;
    plot(maxes(id):step:ending,perct(2,:)*100,'.-');
    xlabel('Number of students in each group');
    ylabel('Percent of experiments with p value < 0.05');
    grid on;
    title(skillname{id});
end





