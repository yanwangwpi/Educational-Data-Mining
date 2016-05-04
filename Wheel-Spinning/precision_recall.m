load predict_actual5_deter;

% trim prediction results to max opp
% index = (predict_actual5_deter(:,3)==predict_actual5_deter(:,4)) | (predict_actual5_deter(:,3)==opp_limit-1);
% predict_actual_trimmed = predict_actual5_deter(index,:);
% index = predict_actual_trimmed(:,4)>=10;
% predict_actual_trimmed(index,4)=9;
% index = (predict_indeter(:,3)==predict_indeter(:,4)) | (predict_indeter(:,3)==opp_limit-1);
% predict_indeter_trimmed = predict_indeter(index,:);
% index = predict_indeter_trimmed(:,4)>=10;
% predict_indeter_trimmed(index,4)=9;


precision=[];
recall=[];
for opp=0:opp_limit-1
    index = predict_actual_trimmed(:,4)==opp;
    prec = sum(predict_actual_trimmed(index,6)>=0.5 & predict_actual_trimmed(index,7)==1)/...
        sum(predict_actual_trimmed(index,6)>=0.5);
    precision = [precision,prec];
    
    rec = sum(predict_actual_trimmed(index,6)>=0.5 & predict_actual_trimmed(index,7)==1)/...
        sum(predict_actual_trimmed(index,7)==1);
    recall = [recall,rec];
end