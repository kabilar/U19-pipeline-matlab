%{
# Relationship between session & manipulation performed
-> acquisition.Session
-> lab.ManipulationType
---
%}

classdef SessionManipulation < dj.Manual
    
    methods
        
        function insertSessionManipulation(self,key,log)
            % Insert session manipulation record from behavioralfile in towersTask
            % Called at the end of training or when populating session
            % Input
            % self         = acquisition.Session instance
            % key          = structure with required fields: (subject_fullname, date, session_no)
            % log          = behavioral file as stored in Virmen
            
            if isfield(log.animal, 'manipulationType') && ~contains(log.animal.manipulationType, 'none')
                key.manipulation_type = log.animal.manipulationType;
                insert(self, key, 'IGNORE');
            end
            
        end
        
        function ingest_previous_optogenetic_sessions(self)
            % Ingest previous optogenetics session manipulation records
            % Read through all behavior files and search for optogenetic data fields.
            
            % All sessions not previously inserted
            prev_sessions = fetch(acquisition.SessionStarted - self);
            
            opto_sessions = 0;
            for i=1:length(prev_sessions)
                [opto_sessions i length(prev_sessions)]
                [status, data] = lab.utils.read_behavior_file(prev_sessions(i));
                if status
                    log = data.log;
                    block_1 = log.block(1);
                    %Check if block has field named lsrepoch
                    if isstruct(block_1) && isfield(block_1, 'lsrepoch')
                        opto_sessions = opto_sessions + 1;
                        key = prev_sessions(i);
                        key.manipulation_type = 'optogenetics';
                        insert(self, key, 'IGNORE');
                    end
                end
            end
            
            
        end
    end
    
    
end