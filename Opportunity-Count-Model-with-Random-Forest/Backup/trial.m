% a1 = [];
% for id = 1:5:75
%     a1=[a1,mean(rmse(id:id+4))];
% end
% 
% b1 = [];
% for id = 1:15
%     b1=[b1,mean(rmse(id:5:end))];
% end

% tol=[];
% for oppor =1:15
% index = data_origin(:,i_opp)==oppor;
% tol = [tol;sum(index)];
% end

load rmse_tol;
rmse=[];
for id = 1:5
    data = rmse_tol{id};
    tmp=[];
    for opp = 1:15
        index = data(:,3)==opp;
        tmp = [tmp,(mean((data(index,1)-data(index,2)).^2))^0.5];
    end
    rmse=[rmse;tmp];
end
rmse1 = mean(rmse);
% figure;
plot([1:15]',rmse1);

load residual_all;
rmse=[];
for id = 1:5
    data = residual_all{id};
    tmp=[];
    for opp = 1:15
        index = data(:,3)==opp;
        tmp = [tmp,(mean((data(index,1)-data(index,2)).^2))^0.5];
    end
    rmse=[rmse;tmp];
end
rmse2 = mean(rmse);
hold on;
plot([1:15]',rmse2,'k');

load residual_all1;

rmse=[];
for id = 1:5
    data = residual_all1{id};
    tmp=[];
    for opp = 1:15
        index = data(:,3)==opp;
        tmp = [tmp,(mean((data(index,1)-data(index,2)).^2))^0.5];
    end
    rmse=[rmse;tmp];
end
rmse3 = mean(rmse);
hold on;
plot([1:15]',rmse3,'r');

load residual_all4;
rmse=[];
for id = 1:5
    data = residual_all4{id};
    tmp=[];
    for opp = 1:15
        index = data(:,3)==opp;
        tmp = [tmp,(mean((data(index,1)-data(index,2)).^2))^0.5];
    end
    rmse=[rmse;tmp];
end
rmse3 = mean(rmse);
hold on;
plot([1:15]',rmse3,'g');

rmse33 = [0.433808459
0.429311069
0.43794646
0.435397248
0.421124731
0.417559307
0.420609623
0.430273244
0.426136022
0.450634763
0.479225371
0.474086504
0.467439968
0.460267339
0.448992493
];
hold on;
plot([1:15]',rmse33,'r');

rmse22=[0.446243985
0.439007256
0.441960094
0.441867116
0.429368539
0.42553225
0.431686722
0.436155687
0.435987649
0.463018332
0.487918262
0.479539884
0.47832559
0.472897125
0.457050474
];
hold on;
plot([1:15]',rmse22,'k');

num =[];
for oppor =1:15
index = data_origin(:,i_opp)==oppor;
num = [num,sum(index)];
end

tol=[];
for id = 1:5:75
    tol = [tol,mean(rmse(id:id+4))];
end