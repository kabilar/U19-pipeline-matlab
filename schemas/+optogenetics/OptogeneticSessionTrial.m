%{
# Information of a optogenetic trial
-> acquisition.SessionBlockTrial
-> optogenetics.OptogeneticSession
---
stim_on			                  : tinyint	     # 1 if stimulation was turned on 0 otherwise
t_stim_on			              : TINYBLOB	 # times when laser was turned on
t_stim_off			              : TINYBLOB	 # times when laser was turned off
stim_epoch			              : varchar(32)	 # Which epoch of the trial stimulation was on
%}


classdef OptogeneticSessionTrial < dj.Part
    properties(SetAccess=protected)
        master = optogenetics.OptogeneticSession
    end
           
    methods
        
        function opto_trial_structure = get_all_optogenetic_trials_data(~,session_key, log)
           % Create a trial structure from behavioral file data ready to be inserted on the table
           %Inputs
           % session_key          = primary key information from OptogeneticSession table 
           % log                  = behavioral file data 
           %Outputs
           % opto_trial_structure = structure array with trial information  
           
            total_trials = 0;
            for iBlock = 1:length(log.block)
                              
                nTrials = length([log.block(iBlock).trial.choice]);
                for itrial = 1:nTrials
                    
                    % Get trial information
                    curr_trial = log.block(iBlock).trial(itrial);
                    time_trial = curr_trial.time;
                    total_trials = total_trials + 1;
          
                    
                    %Fill basic opto trial info
                    opto_trial_key = session_key;
                    opto_trial_key.block             = iBlock;
                    opto_trial_key.trial_idx         = itrial;
                    if isfield(curr_trial, 'lsrON')
                        opto_trial_key.stim_on           = curr_trial.lsrON;
                    else
                        opto_trial_key.stim_on       = 0;
                    end
                    
                    %Fill times where stim was on
                    if opto_trial_key.stim_on  == 1
                        if curr_trial.iLaserOn > 0 
                            opto_trial_key.t_stim_on  = time_trial(curr_trial.iLaserOn);
                        else
                            opto_trial_key.t_stim_on  = 0;
                        end
                        if curr_trial.iLaserOff > 0 
                            opto_trial_key.t_stim_off = time_trial(curr_trial.iLaserOff);
                        else
                            opto_trial_key.t_stim_off = 0;
                        end
                    else
                        opto_trial_key.t_stim_on  = 0;
                        opto_trial_key.t_stim_off = 0;
                    end
                    
                    %Fill epoch where stim was on
                    opto_trial_key.stim_epoch = '';
                    if isfield(curr_trial,'LaserTrialType')
                        if isnumeric(curr_trial.LaserTrialType)
                            opto_trial_key.stim_epoch = num2str(curr_trial.LaserTrialType);
                        else
                            opto_trial_key.stim_epoch = curr_trial.LaserTrialType;
                        end
                    end
                    opto_trial_structure(total_trials) = opto_trial_key;
                end
            end
            
            
        end
            
   
        
    end
        
end
