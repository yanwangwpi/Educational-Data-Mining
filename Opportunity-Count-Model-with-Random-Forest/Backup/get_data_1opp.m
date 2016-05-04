function [train_data, test_data] = get_data_1opp(data, bnet,test,train)
% student_id	skill_ids	correct	opportunity_original	next_problem_correctness
i_user = 3;
i_correct = 4;
i_opp = 4;

% get all unique user id

N = size(bnet.dnodes,2);

% train_data = cell(num_samples,N);
% test_data = cell(num_samples,N);
num_train = 0;
num_test = 0;
indices = mod(data(:,i_user),5)+1;
% sample data one row at a time
%     test = indices==fold;
%     train = ~test;
datatr = data(train,:);
num_samples = size(datatr,1);    
for n = 1:num_samples

	subdata = datatr(n, :);
% 	for i = N/2+1:N
		train_data(n,N/2+1) = {floor(subdata(1, i_correct) + 1)};
        train_data(n,N/2+2) = {[]};
%         num_train = num_train +1;
%     end	
end
datate = data(test,:); 
num_samples = size(datate,1);
for n = 1:num_samples
%     train_data = train_data(1:num_train,:);
    subdata = datate(n, :);
% 	for i = N/2+1:N
		test_data(n,N/2+1) =  {floor(subdata(1, i_correct) + 1)};
        test_data(n,N/2+2) =  {[]};
%         num_test = num_test +1;
%     end	
%     test_data = test_data(1:num_test,:);
end
