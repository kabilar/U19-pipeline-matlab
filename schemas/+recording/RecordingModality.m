%{
# Different modalities for recordings across BRAINCoGS
recording_modality:        varchar(64)           # modalities for recording (ephys, imaging, video_recording, etc.) 
---
modality_description:      varchar(255)          # description for the modality
root_direcory:             varchar(255)          # root directory where that modality is stored (e.g. ephys = /braininit/Data/eletrophysiology)
recording_file_extensions: blob                  # file extensions specific for this modality
%}


classdef RecordingModality < dj.Lookup
    properties (Constant = true)
        
     contents = {
         'electrophysiology', '', '/braininit/Data/eletrophysiology', {'ap.bin', 'ap.meta'}
         'imaging',           '', '/braininit/Data/eletrophysiology', {'.avi', '.tiff','.tif'}
         'video_acquisition', '', '/braininit/Data/video_acquisition', {'.avi', '.mp4'}
      };

    end
    
end