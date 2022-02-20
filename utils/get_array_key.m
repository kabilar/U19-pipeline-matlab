function  key_array =  get_array_key(key, field_name,array_field)
%Function to compose a multiple key array from a single key and an array
% Inputs
% key         =  1x1 struct with reference to a dj table 
% field_name  =  name of the field that it will be 
% field_array =  array with values for the new field for the composed key
% Outputs
% key_array   =  1xn struct with reference to keys specified by array_field and key
% e.g
% key = 
% 
%   struct with fields:
% 
%     subject_fullname: 'efonseca_jj016'
%         session_date: '2021-02-28'
%                block: 2
%
% field_name   = 'trial_idx'
% array_field  = [1,2,3]
% key_array    = get_array_key(key, field_name,array_field)
% key_array
%   1×3 struct array with fields:
% 
%     subject_fullname     {'efonseca_jj016', 'efonseca_jj016', 'efonseca_jj016'}
%     session_date         {'2021-02-28',         '2021-02-28',     '2021-02-28'}
%     block                [           2,                    2,                2]
%     trial_idx            [           1,                    2,                3]

for i=1:length(array_field)
    aux_key = key;
    if iscell(array_field)
        aux_key.(field_name) = array_field{i};
    else
        aux_key.(field_name) = array_field(i);
    end
    
    key_array(i) = aux_key;

end