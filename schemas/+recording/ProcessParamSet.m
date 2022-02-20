%{
# Parameters related to stimulation control by software during session
process_paramset_idx:         smallint
---
-> RecordingModality
process_paramset_desc='':     varchar(128)    # string that describes parameter set
process_paramset_hash:       UUID            # uuid hash that encodes parameter dictionary
process_paramset:               longblob        # dictionary of all applicable parameters
%}

classdef ProcessParamSet < dj.Lookup
    properties (Constant = true)
    end
    
    
     methods
        function try_insert(self, key)
            %Insert a new record on software parameters table (additional check for repeated params)
            % Inputs
            % key = structure with information of the record (preprocess_paramset_desc, preprocessing_params)
            
            %Check minimum field
            if ~isfield(key, 'process_paramset')
                    error('Structure to insert need a field named: process_paramset')
            end
            
            %Convert parameters to uuid
            uuidParams = struct2uuid(key.process_paramset);
            
            %Check if uuid already in database
            params_UUID = get_uuid_params_db(self, 'process_paramset_hash', uuidParams);
            if ~isempty(params_UUID)
                 error(['This set of parameters were already inserted:' newline, ...
                          'process_paramset_idx = ' num2str(params_UUID.process_paramset_idx), newline, ...
                          'process_paramset_desc = ' params_UUID.process_paramset_desc]);
            end
            
            %Finish key data
            key.process_paramset_hash        = uuidParams;
            if ~isfield(key, 'process_paramset_desc')
                key.process_paramset_desc = ['Soft Parames inserted on: ' datestr(now)];
            end
            
            insert(self, key);

        end
    end
    
end
