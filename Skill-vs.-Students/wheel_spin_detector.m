function wheel_spin = wheel_spin_detector(seq)
% This function is used to detect wheel spinning given sequence of
% response seq
mastery_speed = mastery_speed_calculator(seq);
if mastery_speed==-1
    if length(seq)>=10
        wheel_spin=1;
    else
        wheel_spin = -1;
    end
else
    if mastery_speed >10
        wheel_spin=1;
    else
        wheel_spin=0;
    end
end
    