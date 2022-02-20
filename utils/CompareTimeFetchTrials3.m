 
 
clearvars;
this_path = fileparts(mfilename('fullpath'));
file2save = fullfile(this_path, 'session_time_fetch_comp3.mat');
key = struct();
key.subject_fullname = 'emdiamanti_gps11';
 
session_struct = fetch(proj(acquisition.Session,'session_location->sess_loc') * acquisition.SessionStarted & key, ...
    'remote_path_behavior_file', 'ORDER BY session_date');
 
num_sessions = length(session_struct);
session_time_fetch = nan(num_sessions, 2);
 
for j=1:num_sessions
    
    [j num_sessions]
    ac_session = j;
    
    first_who = rand();
    
    if first_who < 0.5
        tic
        trial_struct = fetch(behavior.TowersBlockTrialOld & session_struct(ac_session),'*');
        session_time_fetch(j, 1)  = toc;
        
        tic
        trials_struct = fetch(behavior.TowersBlockTrial & session_struct(ac_session),'*');
        session_time_fetch(j, 2)  = toc;
    else 
        tic
        trial_struct = fetch(behavior.TowersBlockTrial & session_struct(ac_session),'*');
        session_time_fetch(j, 2)  = toc;
        
        tic
        trials_struct = fetch(behavior.TowersBlockTrialOld & session_struct(ac_session),'*');
        session_time_fetch(j, 1)  = toc;
        
    end
    
end
 
save(file2save, 'session_time_fetch', '-v7.3')
 
 

