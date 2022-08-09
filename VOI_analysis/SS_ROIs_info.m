%% Rois bilateral info
clear all, close all, clc
marsbar

ROIs = {'hMT', 'FEF', 'IPS', 'SPL', 'V3A'};

Subjects = 1:25;
Subjects = Subjects';

xr = zeros(25,1);
yr = zeros(25,1);
zr = zeros(25,1);
Sizer = zeros(25,1);
xl = zeros(25,1);
yl = zeros(25,1);
zl = zeros(25,1);
Sizel = zeros(25,1);

for rr = 1:5
    
    for sub = 1:25
        
        ROIr = dir(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/VOI_%s_right_*', sub, ROIs{rr}));
        ROIl = dir(sprintf('/DATAPOOL/VPHYSTERESIS/BIDS-VP-HYSTERESIS/derivatives/spm_main/sub-%02d/VOIs/VOI_%s_left_*', sub, ROIs{rr}));
        
        if length(ROIr.name) >22
            cd(ROIr.folder);
            load(ROIr.name);
            roi = struct(roi);
            nvoxelsr = length(roi.XYZ);
            xyzr = strsplit(ROIr.name, '_');
            Xr = str2num(cell2mat(xyzr(4))); 
            Yr = str2num(cell2mat(xyzr(5))); 
            Zr = str2num(cell2mat(xyzr(6)));
        elseif length(ROIr.name) <22
            cd(ROIr.folder);
            load(ROIr.name);
            roi = struct(roi);
            nvoxelsr = 268;
            xyzr = roi.centre;
            Xr = xyzr(1);
            Yr = xyzr(2);
            Zr = xyzr(3);
        
        end
        
       if length(ROIl.name) >22
            cd(ROIl.folder);
            load(ROIl.name);
            roi = struct(roi);
            nvoxelsl = length(roi.XYZ);
            xyzl = strsplit(ROIl.name, '_');
            Xl = str2num(cell2mat(xyzl(4))); 
            Yl = str2num(cell2mat(xyzl(5))); 
            Zl = str2num(cell2mat(xyzl(6)));
        elseif length(ROIl.name) <22
            cd(ROIl.folder);
            load(ROIl.name);
            roi = struct(roi);
            nvoxelsl = 268;
            xyzl = roi.centre;
            Xl = xyzl(1);
            Yl = xyzl(2);
            Zl = xyzl(3);
        
        end
        xr(sub,1) = Xr;
        yr(sub,1) = Yr;
        zr(sub,1) = Zr;
        Sizer(sub,1) = nvoxelsr;
        xl(sub,1) = Xl;
        yl(sub,1) = Yl;
        zl(sub,1) = Zl;
        Sizel(sub,1) = nvoxelsl;
    end
    t = table(Subjects, xl, yl, zl, Sizel, xr, yr, zr, Sizer);

    writetable(t, sprintf('/DATAPOOL/VPHYSTERESIS/%s_details.xls',ROIs{rr}))
    
end

%% Cluster-based localizer MT
Subjects = 1:25;
Subjects = Subjects';

rX = zeros(25,1);
rY = zeros(25,1);
rZ = zeros(25,1);
size_rMT = zeros(25,1);
lX = zeros(25,1);
lY = zeros(25,1);
lZ = zeros(25,1);
size_lMT = zeros(25,1);

for sub = 1:25
    % Check files
    rMT_file = dir(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/ROIs/right_hMT+_*', sub));
    lMT_file = dir(sprintf('/DATAPOOL/VPHYSTERESIS/Backupsim02/BIDS-VP-HYSTERESIS/sub-%02d/ROIs/left_hMT+_*', sub));
    
    % Right hMT+ file
    rMT = load(fullfile(rMT_file.folder, rMT_file.name));
    rMT = struct(rMT.roi); %convert roi to struct
    
    size_rMT(sub,1) = length(rMT.XYZ); %size of right hMT cluster
    rROI = struct(rMT.maroi); % to get to the fields of the ROI
    coordinater = strsplit(rROI.descrip, '[');
    rxyz = strsplit((coordinater{2}), ' ');
    rX(sub,1) = str2num(cell2mat(rxyz(1)));
    rY(sub,1) = str2num(cell2mat(rxyz(2)));
    rZ(sub,1) = str2num(rxyz{3}(1:end-1));
    
    % Left hMT+
    lMT = load(fullfile(lMT_file.folder, lMT_file.name));
    lMT = struct(lMT.roi); %convert roi to struct
    
    size_lMT(sub,1) = length(lMT.XYZ); %size of right hMT cluster
    lROI = struct(lMT.maroi); % to get to the fields of the ROI
    coordinatel = strsplit(lROI.descrip, '[');
    lxyz = strsplit((coordinatel{2}), ' ');
    lX(sub,1) = str2num(cell2mat(lxyz(1)));
    lY(sub,1) = str2num(cell2mat(lxyz(2)));
    lZ(sub,1) = str2num(lxyz{3}(1:end-1));
    
end

t = table(Subjects, lX,lY, lZ, size_lMT, rX, rY, rZ, size_rMT);
writetable(t, '/DATAPOOL/VPHYSTERESIS/Cluster_hMT_localizer_details.xls');