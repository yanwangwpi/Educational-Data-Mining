function mastery_speed = mastery_speed_calculator(seq)
% This function is used to calculate mastery speed given sequence of
% response seq
mastery_speed = -1;
data_length = length(seq);
if data_length>2  
    for i = 3:data_length
        if all(seq(i-2:i)==[1;1;1])
            mastery_speed=i;
            break;
        end
    end
end