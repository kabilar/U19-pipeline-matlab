

clearvars
this_path = fileparts(mfilename('fullpath'));
file2save = fullfile(this_path, 'towerSessions_diff_arrays.mat');
file2savekeys = fullfile(this_path, 'towerSessions_diff_arrays_keys.mat');

ts = behavior.TowersSession;
trial_table = ts.aggr(behavior.TowersBlockTrial, 'count(trial_idx)->num_trials');
session_struct = fetch(behavior.TowersSession * trial_table, ...
    'rewarded_side', 'chosen_side', 'maze_id', ...
    'num_towers_r', 'num_towers_l', 'num_trials', 'ORDER BY session_date desc');
num_diff_trials = 0;


num_diff_sessions = 0;
for j=1:length(session_struct)
    
    [j length(session_struct)]
    
    bad_session = false;
    aux_key.subject_fullname      = session_struct(j).subject_fullname;
    aux_key.session_date          = session_struct(j).session_date;

    session_info = struct();
    session_info.num_towers_r     = length(session_struct(j).num_towers_r);
    session_info.num_towers_l     = length(session_struct(j).num_towers_l);
    session_info.chosen_side      = length(session_struct(j).chosen_side);
    session_info.maze_id          = length(session_struct(j).maze_id);
    session_info.num_trials       = session_struct(j).num_trials;
    
    fields = fieldnames(session_info);
    
    for i=2:length(fields)
        
        if session_info.(fields{1}) ~= session_info.(fields{i})
            bad_session = true;
            break
        end
    end
    
    if bad_session
        num_diff_sessions = num_diff_sessions + 1
        aux_key = struct();
        aux_key.subject_fullname = session_struct(j).subject_fullname;
        aux_key.session_date     = session_struct(j).session_date;
        aux_key.session_number   = session_struct(j).session_number;
        session_diff_struct_keys(num_diff_sessions) = aux_key;
        
        aux_key = catstruct(aux_key, session_info);
        session_diff_struct(num_diff_sessions) = aux_key;
    end

end

save(file2save, 'session_diff_struct', '-v7.3')
save(file2savekeys, 'session_diff_struct_keys', '-v7.3')
        
        
