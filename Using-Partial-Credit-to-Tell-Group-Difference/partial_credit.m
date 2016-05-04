% This function is used to calculate partial credit
function partial  = partial_credit(correct, hint_used, hint_all, attempt)
% The number of columns of hint_used, hint_total and attempt should be the
% same
%% version 1 
% % num is number of questions
% num = size(hint_used,2);
% 
% hint = hint_used./hint_total;
% % index1 to find hint percent<=0.25
% index1 = hint<=0.25;
% hint(index1) = hint(index1);
% index2 = hint>0.25 & hint<=0.5;
% hint(index2) = hint(index2);
% index3 = hint>0.5 & hint<=0.75;
% hint(index3) = hint(index3);
% index4 = hint>0.75;
% hint(index4) = hint(index4);
% 
% partial = 1-hint;
% % index = partial~=1;
% % partial(index)= partial(index)*ratio_hint;
% 
% index1 = attempt==2;
% partial(index1) = partial(index1)-0.3;
% index2 = attempt==3;
% partial(index2) = partial(index2)-0.3*2;  
% index3 = attempt==4;
% partial(index3) = partial(index3)-0.3*3; 
% index4 = attempt>=5;
% partial(index4) = partial(index4)-0.3*(attempt(index4)-1); 
% 
% index = partial<0;
% partial(index)=0;
% index = partial<1;
% partial(index) = partial(index)*ratio_correct;

%% version 2
index1 = attempt==1 & correct==1 & hint_used==0;
index2 = ~index1 & attempt<3 & hint_used==0;
index3 = ~index1 & ~index2 & ((attempt<=3 & hint_used==0) |(hint_used==1 & hint_used<hint_all));
index4 = ~index1 & ~index2 & ~index3 & ((attempt<5 & hint_used<hint_all) |(hint_used>1 & hint_used<hint_all));
index5 = ~index1 & ~index2 & ~index3 & ~index4;

partial = zeros(size(correct));
partial(index1) = 1;
partial(index2) = 0.8;
partial(index3) = 0.7;
partial(index4) = 0.3;
partial(index5) = 0;
