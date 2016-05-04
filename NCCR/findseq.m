function [tell,index] = findseq(data,seq)
num = size(data,1);
tell=0;
index = nan;

for id  =1:num-seq+1
    if sum(data(id:id+seq-1))==seq
        tell = 1;
        index = id+seq;
        return;
    end
end
        