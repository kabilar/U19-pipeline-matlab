%{
# Provisional table for traces obtained from Suite2p
-> imaging.FieldOfView
roi_idx                     : int                           
---
f_roi_raw                   : longblob                           
f_surround_raw              : longblob
spiking                     : longblob
is_cell                     : blob
f0_roi_raw                  : float     # baseline for each cell, calculated on f_roi_raw
dff_roi_uncorrected         : longblob  # delta f/f, baseline corrected but no neuropil correction, 1 x nFrames (calculated from f_roi_raw and f0_roi_raw)
skew                        : float     # skewness of neu corrected trace
std                         : float     # std of neu corrected trace
compact                     : float     # 1 means disk
med                         : blob      # pos on FOV
%}

classdef Suite2ptrace < dj.Imported
    methods(Access=protected)
    
        function makeTuples(self, key)
            data_info = fetch(imaging.FieldOfView & key, 'fov_directory');
            
            for iFOV = [data_info.fov]
            roi_directory = lab.utils.format_bucket_path(data_info.fov_directory);
            load(fullfile(roi_directory, 'suite2p\plane0\Fall.mat'));
            
            for iROI = 1:size(F, 1)
               % do the dF/F here first
               f0  = halfSampleMode(F(iROI,:)');
               dff = F(iROI,:)/f0 - 1; 
                
               thisresult = key; 
               thisresult.roi_idx                    = iROI; 
               thisresult.f_roi_raw                  = F(iROI,:); 
               thisresult.f_surround_raw             = Fneu(iROI,:);
               thisresult.spiking                    = spks(iROI,:);
               thisresult.is_cell                    = iscell(iROI,:);
               thisresult.f0_roi_raw                 = f0;
               thisresult.dff_roi_uncorrected        = dff;
               thisresult.skew                       = stat{iROI}.skew;
               thisresult.std                        = stat{iROI}.std;
               thisresult.compact                    = stat{iROI}.compact; 
               thisresult.med                        = stat{iROI}.med; 
               
                self.insert(thisresult)
               
            end
            
            end
    end
    end
end