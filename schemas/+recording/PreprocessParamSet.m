%{
# Parameters related to stimulation control by software during session
preprocess_paramset_idx:      smallint
---
-> RecordingModality
preprocess_paramset_desc='':  varchar(128)    # string that describes parameter set
preprocess_paramset_hash:     UUID            # uuid hash that encodes parameter dictionary
preprocess_paramset:          longblob        # dictionary of all applicable parameters
%}

classdef PreprocessParamSet < dj.Lookup
    properties (Constant = true)
    end
    
    
     methods
        function try_insert(self, key)
            %Insert a new record on software parameters table (additional check for repeated params)
            % Inputs
            % key = structure with information of the record (preprocess_paramset_desc, preprocess_params)
            
            %Check minimum field
            if ~isfield(key, 'preprocess_paramset')
                    error('Structure to insert need a field named: preprocess_paramset')
            end
            
            %Convert parameters to uuid
            uuidParams = struct2uuid(key.preprocess_paramset);
            
            %Check if uuid already in database
            params_UUID = get_uuid_params_db(self, 'preprocess_paramset_hash', uuidParams);
            if ~isempty(params_UUID)
                 error(['This set of parameters were already inserted:' newline, ...
                          'preprocess_paramset_idx = ' num2str(params_UUID.preprocess_paramset_idx), newline, ...
                          'preprocess_paramset_desc = ' params_UUID.preprocess_paramset_desc]);
            end
            
            %Finish key data
            key.preprocess_paramset_hash        = uuidParams;
            if ~isfield(key, 'preprocess_paramset_desc')
                key.preprocess_paramset_desc = ['Soft Params inserted on: ' datestr(now)];
            end
            
            insert(self, key);

        end
    end
    
end
