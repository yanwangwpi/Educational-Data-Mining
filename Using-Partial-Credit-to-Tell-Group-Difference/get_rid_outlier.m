function [data_vector,index] = get_rid_outlier(data_vector)
% This file is used to get rid of outliers of data_vector

q = quantile(data_vector,[.25 .50 .75]);
k = 1.5;
low = q(1)-k*(q(3)-q(1));
high = q(3)+k*(q(3)-q(1));
index = data_vector<high & data_vector>low;
data_vector = data_vector(index);

