% MAIN

% build model
bnet = make_knowledge_model_1opp();


% 1order_id	2assignment_id	3student_id	4correct	5attempt_count	6ms_first_response	
% 	7hint_countpercentage	8sequence_id 9first_action	10action_1
% 11action_2	12action_3	13action_4	14action_5, 15NPC
load data1;

dataLen = size(data,1);
skill_ids = unique(data(:,8)); 


r2_tol=[];

residual_tab=[];
rmse = [];
for fold = 1:5
actual_tol = [];
pred_tol =[];
cur_tol=[];
    for id_skill = 1:length(skill_ids)
    index = data(:,8)==skill_ids(id_skill);

    subdata = data(index,:);
    indices = mod(subdata(:,3),5)+1;
% sample data one row at a time
    test = indices==fold;
    train = ~test;
    actual = subdata(test,14);
    if sum(test)>0 & sum(train)>0
    [train_data, test_data] = get_data_1opp(subdata, bnet,test,train);
    bnet_with_learned_parameters = fit_parameters(bnet, train_data);
    [cur, pred] = predict_data(bnet_with_learned_parameters, test_data);
    cur_tol = [cur_tol;cur(:)];
    actual_tol = [actual_tol;actual];
    pred_tol = [pred_tol;pred(:)];
    end
    end
    length(pred_tol)
    r2_tol = [r2_tol,rsquared(actual_tol,pred_tol)];
    residual = actual_tol-pred_tol;
    residual_tab = [residual_tab;residual];
    rmse = [rmse,(mean(residual.^2))^0.5];
end


