

% A detailed description for 
param_struct.software_parameter_description =  'P=0.21, lsrepoch=cue';

% All parameters goes in here 
%(P_on and lsrepoch are the common and needed for current opto experiments)
param_struct.software_parameters.P_on     = 0.21;
param_struct.software_parameters.lsrepoch = 'cue';

% New parameters could be inserted if needed
%param_struct.software_parameters.new_param = 'new_value';

%Insert parameter
try_insert(optogenetics.OptogeneticSoftwareParameter, param_struct)