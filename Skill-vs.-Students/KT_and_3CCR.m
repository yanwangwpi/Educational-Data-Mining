% This function is used to show that KT and 3CCR are generally consistent.

clc;
close all;
clear all;


pL0_range = [0.05:0.05:0.5];
pT_range = [0.05:0.05:0.5];
pS_range = [0.05:0.05:0.5];
pG_range  = [0.05:0.05:0.25];


pL_all =[];
for pL0 = pL0_range
    pT_all=[];
    for pT = pT_range
        pS_all=[];
        for pS = pS_range
            pG_all=[];
            for pG = pG_range
                pL1 = pL0;
                for id = 1:3
                    pL2_c = pL1*(1-pS)/(pL1*(1-pS)+(1-pL1)*pG);
                    pL2_w = pL1*(pS)/(pL1*(pS)+(1-pL1)*(1-pG));
                    pL2 = pL2_c+(1-pL2_c)*pT;
                    pC2 = pL1*(1-pS)+(1-pL1)*pG;
                    pL1 = pL2;
                end
                pG_all=[pG_all,pL1];
            end
            pS_all=[pS_all,pG_all];
        end
        pT_all = [pT_all; pS_all];
    end
    pL_all = [pL_all;pT_all];
end

imagesc(pS_range,pL0_range, pL_all)

xlabel('Slip rate, at each slip rate, guess rate ranges from 0.05 to 0.25, step by 0.05')
ylabel('Initial rate, at each initial rate, transfer rate ranges from 0.05 to 0.5, step by 0.05')
