%{
recording_id:                      INT(11) AUTO_INCREMENT                  # Unique number assigned to each recording
-----
-> RecordingModality
-> lab.Location
-> StatusRecordingDefinition                                               # current status for recording in the pipeline
(def_preprocess_paramset_idx)-> PreprocessParamSet(preprocess_paramset_idx)# reference to params to preprocess recording (possible to inherit to recordigprocess)
(def_process_paramset_idx)   -> ProcessParamSet(process_paramset_idx)      # reference to params to process recording  (possible to inherit to recordigprocess)                                                      
task_copy_id_pni=null:             UUID                                    # id for globus transfer task raw file local->cup
inherit_params_recording=1:        boolean                                 # all RecordingProcess from a recording will have same paramSets
recording_directory:               varchar(255)                            # relative directory where the recording will be stored on cup
local_directory:                   varchar(255)                            # local directory where the recording is stored on system
%}

classdef Recording< dj.Manual
    
end