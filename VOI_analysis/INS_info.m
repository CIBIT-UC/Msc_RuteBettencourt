%% 
clear all, close all, clc
marsbar;
Subjects = 1:25;
Subjects = Subjects';
x = zeros(25,1);
y = zeros(25,1);
z = zeros(25,1);
Size = zeros(25,1);

for sub = 1:25
    
    INS = dir(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs10mm/VOI_insula_right_*', sub));
    
    if length(INS) ~=0
        cd(INS.folder);
        load(INS.name);
        roi = struct(roi);
        nvoxels = length(roi.XYZ);
        xyz = strsplit(INS.name(21:end), '_');
        X = str2num(cell2mat(xyz(1))); 
        Y = str2num(cell2mat(xyz(2))); 
        Z = str2num(cell2mat(xyz(3)));
    else
        cd('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main')
        load('insula_roi.mat')
        roi = struct(roi);
        xyz = roi.centre;
        X = xyz(1);
        Y = xyz(2);
        Z = xyz(3);
        nvoxels = 268; %((4/3)*pi*r^3)/volumevoxel
    end
    
    x(sub,1) = X;
    y(sub,1) = Y;
    z(sub,1) = Z;
    Size(sub,1) = nvoxels;
end

t = table(Subjects, x, y, z, Size);

%save('/DATAPOOL/VPHYSTERESIS/Insula_details.txt', 't')
writetable(t, '/DATAPOOL/VPHYSTERESIS/Insula10_details.xls')