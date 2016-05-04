% This file is used to draw curve data points VS p-value



clc;
clear all;
% close all;

skillID = {'10265','6921','10195','11829','11898','11893'};
skillNS = [150,150,150,150,150,150,150];


max_num = 15;
ii_seq = 1;
ii_stu = 2;
ii_num = 3;
ii_prior_count = 4;
ii_prior_suc = 5;
ii_correct = 6;
ii_hint = ii_correct+max_num;
ii_hall = ii_hint+max_num;
ii_att = ii_hall+max_num;

alfa = 0.5;
beta = 0.5;

perct_tol=[];
item = 2;
num_all=[];
sta_all=[];
for id_skill = 1:6
    load(strcat('data_new',skillID{id_skill}));
    
    %% select data
    
%     index = data_new(:,ii_seq)==SB(id_skill);
%     data = data_new(index,:);
    data = data_new;
    
    index = data(:,ii_num)>=3 & data(:,ii_prior_count)>=20;
    data = data(index,:);
    
    for item = 2
        
        data_mean = nanmean(data(:,ii_correct:ii_correct+item),2);
        data_mean = [data_mean,nanmean(data(:,ii_hint:ii_hint+item)./data(:,ii_hall:ii_hall+item),2)];
        data_mean = [data_mean,nanmean(data(:,ii_att:ii_att+item),2)-1];
        
        partial  = partial_credit(data(:,ii_correct:ii_correct+item),data(:,ii_hint:ii_hint+item), data(:,ii_hall:ii_hall+item), (data(:,ii_att:ii_att+item)));
        partial = nanmean(partial(:,1:3),2);
        %  partition into 5 level groups
        cutline = prctile(data(:,ii_prior_suc),[50]);
        
        total = 20;
        
        curve =[];
        feature=[];
        
            index = data(:,ii_prior_suc)<cutline(1);
            high = data_mean(index,:);
            high_partial = partial(index,:);
            index = data(:,ii_prior_suc)>=cutline(1);
            low = data_mean(index,:);
            low_partial = partial(index,:);
            
            low_data_b = low(:,1);
            high_data_b = high(:,1);
            
            db = cohend(low_data_b,high_data_b);
            d = cohend(low_partial,high_partial);
            
            Nx = 2*(norminv(alfa/2,0,1)-norminv(1-beta,0,1))^2/db^2;
            Nx = ceil(Nx);
            %%
            
            %resample without replacement
            lowN  =size(low,1);
            highN = size(high,1);
            
            NS = 5000;
            start = 20;
            step = 10;
            ending = 200;
            effect_size_groupb=[];
            effect_size_group=[];
            for k = start:step:ending
                effect_size_groupkb=[];
                effect_size_groupk=[];
                ptmpb=[];
                ptmp=[];
                numb=0;
                num= 0;
                for id = 1:NS
                    lowI = randsample(lowN,k,'true');
                    highI = randsample(highN,k,'true');
                    
                    
                    % ANOVAL of binary
                    try
                        % p = anova1(X,[],'off');
                        [h,pb] = ttest2(low_data_b(lowI,:),high_data_b(highI,:));
                        ptmpb = [ptmpb,pb(1)];
                    catch
                        numb = numb+1;
                    end
                    
                   % ANOVAL of partial
                    try
                        % p = anova1(X,[],'off');
                        [h,p] = ttest2(low_partial(lowI,:),high_partial(highI,:));
                        ptmp = [ptmp,p(1)];
                    catch
                        num = num+1;
                    end
                    
                    effect_size_groupkb = [effect_size_groupkb;pb(1), cohend(low_data_b(lowI,:),high_data_b(highI,:))];
                    effect_size_groupk = [effect_size_groupk;p(1), cohend(low_partial(lowI,:),high_partial(highI,:))];
                    % [h,p] = ttest2(group_low_data(groupI),inter_low_data(interI));
                end
                index = effect_size_groupkb(:,1)<0.05;
                meaneffectb = nanmean(effect_size_groupkb(index,2));
                stdeffectb = nanstd(effect_size_groupkb(index,2));
                perctb=sum(ptmpb<0.05)/(NS-numb);
                
                index = effect_size_groupk(:,1)<0.05;
                meaneffect = nanmean(effect_size_groupk(index,2));
                stdeffect = nanstd(effect_size_groupk(index,2));
                
                perct=sum(ptmp<0.05)/(NS-num);
                
                effect_size_groupb = [effect_size_groupb;k,db,meaneffectb,stdeffectb,perctb,d];
                effect_size_group = [effect_size_group;k,db,meaneffect,stdeffect,perct,d];
            end
    end
    effect_size_skillb{id_skill} = effect_size_groupb;
    effect_size_skill{id_skill} = effect_size_group;
end

color_set = {[0 0 1],[0 0 0],[1 0 0]};

for group = 1
    figure;
    hold on;
    for id = 1:6
        subplot(3,2,id);
        this_group = effect_size_skillb{id};
        hold on
        plot(this_group(:,1),this_group(:,2),'k');
        plot(this_group(:,1),this_group(:,end),'g');
        plot(this_group(:,1),this_group(:,3));
        this_group = effect_size_skill{id};
        plot(this_group(:,1),this_group(:,3),'r');
        xlabel('Number of subjects in each group');
        ylabel('Effect size');
        
    end
end

for group = 2:2:10
    figure;
    hold on;
    for item = 0:2
        this_item = effect_size_item{item+1};
        this_group = this_item{group};
        plot(this_group(:,1),this_group(:,5),'Color',color_set{item+1});
        xlabel('Number of subjects in each group');
        ylabel('Power');
    end
end


