%{
-> acquisition.Session
block                       : tinyint                       # block number
---
%}

classdef SessionBlock < dj.Imported
    properties
        keySource =  acquisition.Session & struct('is_bad_session', 0);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            [status, data] = lab.utils.read_behavior_file(key);
            if status
                try
                    %Check if it is a real behavioral file
                    log = data.log;
                    if isfield(log, 'session')
                        %Insert Blocks and trails from BehFile
                        self.insertSessionBlockFromFile(key,log)
                    else
                        disp(['File does not match expected Towers behavioral file: ', data_dir])
                    end
                catch err
                    disp(err.message)
                    sprintf('Error in here: %s, %s, %d',err.stack(1).file, err.stack(1).name, err.stack(1).line )
                end
            end
            
        end
        
    end
    
    % Public methods
    methods
        function insertSessionBlockFromFile(self, key,log)
            % Insert blocks and blocktrials record from behavioralfile
            % Called at the end of training or when populating towersBlock
            % Input
            % self = behavior.TowersBlock instance
            % key  = behavior.TowersSession key (subject_fullname, date, session_no)
            % log  = behavioral file as stored in Virmen
            
            total_trials = 0;
            for iBlock = 1:length(log.block)
                block_tuple = key;
                block_tuple.block = iBlock;
                
                %Concatenate info from all blocks before insert
                block_struct(iBlock) = block_tuple;
                
                nTrials = length([log.block(iBlock).trial.choice]);
                for itrial = 1:nTrials
                    trial_tuple = block_tuple;
                    trial_tuple.trial_idx = itrial;
                    
                    %Concatenate info from all trials before insert
                    total_trials = total_trials + 1;
                    trial_struct(total_trials) = trial_tuple;
                    
                end
                
            end
            
            %Single insert for all session
            self.insert(block_struct);
            insert(acquisition.SessionBlockTrial, trial_struct)
            
        end
    end
end



