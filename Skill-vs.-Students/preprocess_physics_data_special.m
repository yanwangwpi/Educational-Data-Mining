% Preprocess data and generate covariates for the dataset of ANDES physics data from pslc datashop. 
% Data for 08-09 is special

% Input: csv files of assistments skill builders
% Output: Organized MAT file with student id, skill id, correct and
% opportunity count

clc;
close all;
clear all;


source_name = {'fall2008','spring2009'};

for id_file = 1:2
fileID = fopen(strcat('Physics\student_step_All_Data_',source_name{id_file},'.txt'));

tline = fgetl(fileID);
% 1Row	Sample 2Anon Student Id	3Problem Hierarchy	4Problem Name	5Problem View	
% 6Step Name	7Step Start Time	8First Transaction Time	9Correct Transaction Time	
% 10Step End Time	11Step Duration (sec)	12Correct Step Duration (sec)	13Error Step Duration (sec)	
% 14Correct First Attempt	15Incorrects	16Hints	17Corrects	18 Condition 19KC(Default)	20Opportunity(Default)
% 21~30 unimportant
C = textscan(fileID,'%d %s %s %s %s %d %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',...
    'Delimiter','\t');

user_code = C{3};
correct_stirng = C{15};
skill_code = C{26};
opp_code = C{27};

fclose(fileID);


num = size(user_code,1);

correct=[];
for id = 1:num
    if strcmp(correct_stirng{id},'correct')
        correct = [correct;1];
    else
        if strcmp(correct_stirng{id},'incorrect') || strcmp(correct_stirng{id},'hint')
            correct = [correct;0];
        else
            correct = [correct;nan];
        end
    end
end

users = java.util.HashMap;
users_id =zeros(num,1);
count = 1;
for id = 1:num
    this_user = users.get(user_code{id});
    if isempty(this_user)
        users.put(user_code{id},count);
        users_id(id) = count;
        count = count+1;
    else
        users_id(id) = this_user;
    end
end

opps = java.util.HashMap;
opps_id = zeros(num,1);
count = 1;
for id = 1:num
    this_code  =opp_code{id};
    hastide = findstr(this_code,'~~');
    if isempty(hastide)
        this_num = 1;
        opp_tmp{1} = this_code;
    else
        this_num = length(hastide)+1;
        opp_tmp{1} = this_code(1:hastide(1)-1);
        if this_num>2
            for id_tmp = 2:this_num-1
                opp_tmp{id_tmp} = this_code(hastide(id_tmp-1)+2:hastide(id_tmp)-1);
            end
        end
        opp_tmp{this_num} = this_code(hastide(end)+2:end);
    end
    if isempty(opp_tmp{1})
        opps_id(id) = nan;
    else
    opps_id(id) = str2num(opp_tmp{1});
    end

    for id_tmp = 2:this_num

            opps_id = [opps_id;str2num(opp_tmp{id_tmp})];
            users_id = [users_id;users_id(id)];
            correct = [correct;correct(id)];
    end
end

skills = java.util.HashMap;
skills_id = zeros(num,1);
count = 1;
for id = 1:num
    this_code  =skill_code{id};
    hastide = findstr(this_code,'~~');
    if isempty(hastide)
        this_num = 1;
        skill_tmp{1} = this_code;
    else
        this_num = length(hastide)+1;
        skill_tmp{1} = this_code(1:hastide(1)-1);
        if this_num>2
            for id_tmp = 2:this_num-1
                skill_tmp{id_tmp} = this_code(hastide(id_tmp-1)+2:hastide(id_tmp)-1);
            end
        end
        skill_tmp{this_num} = this_code(hastide(end)+2:end);
    end
    if isempty(skill_tmp{1})
        skills_id(id) = nan;
    else
    this_skill = skills.get(skill_tmp{1});
    if isempty(this_skill)
        skills.put(skill_tmp{1},count);
        skills_id(id) = count;
        count = count+1;
    else
        skills_id(id) = this_skill;
    end
    end
    for id_tmp = 2:this_num
        this_skill = skills.get(skill_tmp{id_tmp});
        if isempty(this_skill)
            skills.put(skill_tmp{id_tmp},count);
            skills_id = [skills_id;count];
            count = count+1;
        else
            skills_id = [skills_id;this_skill];

        end
    end
end

index = opps_id==opps_id & correct==correct;
opps_id = opps_id(index);
skills_id = skills_id(index);
users_id = users_id(index);
correct = correct(index);

data = [opps_id,skills_id,users_id,double(correct)];

file_name = strcat('physics_',source_name{id_file},'_raw_data');

save(file_name,'data');
end





