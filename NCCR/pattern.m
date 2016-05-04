% This function is used to calculate the statistics of correctness from
% data
% data has two columns, [correct, duration]
% 1.# of students who has done until this opptunity
% 2. #of correct
% 3. # of NPC 
% 4. # of students who reach this level
% 5. # of students who fail this level
function [ptable,ttable,tgoodtable,tbadtable] = pattern(data,ptable,ttable, tgoodtable,tbadtable)
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
        else 
            [tell,index2] = findseq(data(index:end,1),id+1);
            if tell
                ptable(4,id) = ptable(4,id)+1;
                tgoodtable{id}= [tgoodtable{id},index2-1-1];
            else
                ptable(5,id) = ptable(5,id)+1;
                tbadtable{id}= [tbadtable{id},size(data(index:end,1),1)-1];
            end
        end
        ttable{id}= [ttable{id},sum(data(1:index-1,2))];
    end
end
    




