%% 

clear all, close all, clc
flag = zeros(266, 25);
for sub = 1:25
    TC1 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/insula_run1.mat', sub));
    %TC2 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/insula_run2.mat', sub));
    %TC3 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/insula_run3.mat', sub));
    %TC4 = load(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/insula_run4.mat', sub));
    
    if TC1.y(:,1) < 100
        flag(:,sub) = 1;
    elseif TC1.y(:,1) < 150
        flag(:,sub) = 2;
%     elseif TC3.y(:,1) < 150
%         flag(:,sub) = 3;
%     elseif TC4.y(:,1) < 150
%         flag(:,sub) = 4;
%     
    end

end

%save('INS_TC_flag.mat', 'flag')