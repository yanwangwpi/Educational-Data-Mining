% This function is used to calculate the statistics of correctness from
% data
% data has two columns, [correct, duration]
% 1.# of students who has done until this opptunity
% 2. #of correct
% 3. # of 3 correct in a row
function [ptable,ttable,tgoodtable] = pattern2(data,ptable,ttable, tgoodtable)
num = size(ptable,2);
for id = 1:num
    if size(data,1)-1< id
        break;
    end
    ptable(1,id) = ptable(1,id)+1;
    [tell,index] = findseq(data(1:end-1,1),id);
    if tell
        ptable(2,id) = ptable(2,id)+1;    
        if data(index,1)
            ptable(3,id) = ptable(3,id)+1;
            tgoodtable{id}= [tgoodtable{id},sum(data(1:index-1,2))];
        end
        ttable{id}= [ttable{id},sum(data(1:index-1,2))];
    end
end
    