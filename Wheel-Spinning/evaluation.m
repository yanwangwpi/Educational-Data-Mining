% This file is used to evaluate prediction. Input is a 6 column matrix.
% user, skill, group, num_prac, predict, actual

load predict_actual;


mspess =zeros(10,1);
msop=zeros(10,1);
msest=zeros(10,1);
indeter = zeros(10,1);
tol=0;
skill = unique(data(:,i_skill));
for id = 1:length(skill)
    index=  data(:,i_skill)==skill(id);
    sub = data(index,:);
    user = unique(sub(:,i_user));
    for idu = 1:length(user)
        tol = tol+1;
        index = sub(:,i_user)==user(idu);
        subsub = sub(index,:);
        [opp,I] = max(subsub(:,i_opp));
        if opp==0 | opp==1
            disp('eror');
        end
        opp = opp+1;
        ws = subsub(I,i_ws);
        if ws==0
        mspess(opp) = mspess(opp)+1;
        msop(opp) = msop(opp)+1;
        end
        if ws==-1
            indeter(opp) = indeter(opp)+1;
            if subsub(I,i_pred)>=0.5
                msest(opp) = msest(opp)+1;
            end
        end
    end
end


modifymsest = msest.*PRM(:,1)./PRM(:,2);
tolms = msest+mspess;
modifytolms = modifymsest+mspess;