function [tell3,tell4,tell5,index1] = findpattern(data)

tell3=0;
tell4=0;
tell5 = 0;
index1 = nan;
dataLen = length(data);
patLen = 3;

if dataLen>=5
    for i = patLen: dataLen-2
    if all(data(1-patLen+i:i)==[1;1;1])
        tell3 = 1;
        index1 = i+1;
        if data(i+1)==1
            tell4 =1;
        end
        if data(i+2)==1
            tell5 =1;
        end
        break;
    end
    end
    
end
