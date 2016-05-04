function [train_data, test_data] = get_data(data, bnet,test,train)
% student_id	skill_ids	correct	next_problem_correctness opportunity_original	
i_user = 2;
i_correct = 4;


% get all unique user id

N = size(bnet.dnodes,2);


indices = mod(data(:,i_user),5)+1;
% sample data one row at a time
%     test = indices==fold;
%     train = ~test;
datatr = data(train,:);
users = unique(datatr(:,i_user)); 

num_samples = size(users,1);
  
for n = 1:num_samples

	subdata = datatr(datatr(:,i_user) == users(n), :);
%     opp = (1:size(subdata,1))';
%     subdata = [subdata,opp];
	for i = N/2+1:N
		train_data(n,i) = {floor(subdata(subdata(:, end) == (i - N/2), i_correct) + 1)};
%         num_train = num_train +1;
    end	
end
datate = data(test,:);
users = unique(datate(:,i_user)); 
num_samples = size(users,1);
for n = 1:num_samples
%     train_data = train_data(1:num_train,:);
    subdata = datate(datate(:,i_user) == users(n), :);
%     opp = (1:size(subdata,1))';
%     subdata = [subdata,opp];
	for i = N/2+1:N
		test_data(n,i) = {floor(subdata(subdata(:, end) == (i - N/2), i_correct) + 1)};
%         num_test = num_test +1;
    end	
%     test_data = test_data(1:num_test,:);
end
