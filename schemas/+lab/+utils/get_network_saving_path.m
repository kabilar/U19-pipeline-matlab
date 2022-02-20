function final_data_path = get_network_saving_path(rig_name,subdir)
%Get the network data path to store a behavior file 
%Essentially Replaces C:\Data\subdir from the regular local storage to the corresponding bucket\cup location
% Inputs
% rig_name = RigName as found in lab.Location table
% user_id = Subdirectory where behavioral file is stored (usually user_id)
% Outputs
% final_data_path = Network location for behavior file

% Example
% final_data_path = get_network_saving_path('165a-Rig7-T','alvaros')
%final_data_path =
%
%    '\\cup.pni.princeton.edu\braininit\RigData\training\rig7\alvaros'

query_rig = struct('location', rig_name);
data_path = fetch1(lab.Location & query_rig, 'bucket_default_path');
[~, network_path] =  lab.utils.get_path_from_official_dir(data_path);
 
final_data_path = fullfile(network_path, subdir);

end

