function [actual_performance, pred_performance_cut,opp] = predict_data(bnet,sampdata)

% initialize inference engine
engine = jtree_inf_engine(bnet);

% initialize matrix that will store the prediction of each student's responses
pred_performance = zeros(size(sampdata,1),length(bnet.observed));

% initialize matrix that will store the prediction of each student's knowledge
pred_knowledge = zeros(size(sampdata,1),length(bnet.hidden));

% predict students one at a time
for s=1:size(sampdata,1)
    % predict the student's response and knowledge one opportunity at a time
    student_responses = cell(1,size(bnet.dag,1));
 
    % initialize evidence inference engine with empty response vector
    engine2 = enter_evidence(engine,student_responses);
    for o=1:length(bnet.observed)

        % predict response
        P = marginal_nodes(engine2, bnet.observed(o));
        P = P.T(2);
        pred_performance(s,o) = P;
        
        % enter the student's actual response as evidence in the network
        student_responses(bnet.observed(o)) = sampdata(s,bnet.observed(o));
        
        % predict knowledge
        engine2 = enter_evidence(engine,student_responses);
        P = marginal_nodes(engine2, bnet.hidden(o));
        P = P.T(2);
        pred_knowledge(s,o) = P;
        
    end
    
end

% matrix of actual responses
actual_performance = sampdata(:,bnet.observed(1:end-1))';
pred_performance_part = pred_performance(:,2:length(bnet.observed))';
opp  = kron(ones(size(pred_performance,1),1),1:15)';
nempty_index = ~cellfun(@isempty, actual_performance);
actual_performance = cell2mat(actual_performance(nempty_index)) - 1;

pred_performance_cut = pred_performance_part(nempty_index);
opp = opp(nempty_index);
%AE_performance = 0;
%count = 0;
%for i = 1:size(sampdata,1)
    
%end
% MAE_performance_tab = [];
% RMSE_performance_tab= [];
% for i = 1:500
% MAE_performance = mean(abs(actual_performance(1:i) - pred_performance_cut(1:i)));
% MAE_performance_tab = [MAE_performance_tab,MAE_performance];
% RMSE_performance = (mean((actual_performance(1:i) - pred_performance_cut(1:i)).^2))^0.5;
% RMSE_performance_tab = [RMSE_performance_tab,RMSE_performance];
% end
% 
% disp(ok)


