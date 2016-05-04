function mastery_speed = mastery_speed_calculator_ncorrect(seq,ncorrect)
% This function is used to calculate mastery speed given sequence of
% response seq
mastery_speed = -1;
data_length = length(seq);
if data_length>ncorrect-1
    for i = ncorrect:data_length
        if all(seq(i-ncorrect+1:i)==ones(ncorrect,1))
            mastery_speed=i;
            break;
        end
    end
end