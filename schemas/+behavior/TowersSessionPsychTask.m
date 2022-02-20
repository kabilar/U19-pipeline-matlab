%{
-> behavior.TowersSession
blocks_type: varchar(16)
-----
blocks_delta_data=null      : blob   # num of right - num of left, x ticks for data
blocks_pright_data=null     : blob   # percentage went right for each delta bin for data
blocks_delta_error=null     : blob   # num of right - num of left, x ticks for data confidence interval
blocks_pright_error=null    : blob   # confidence interval for precentage went right of data
blocks_delta_fit=null       : blob   # num of right - num of left, x ticks for fitting results
blocks_pright_fit=null      : blob   # fitting results for percent went right
%}

classdef TowersSessionPsychTask < dj.Computed

    methods(Access=protected)

        function makeTuples(self, key)

            deltaBins           = -15:3:15;       % controls binning of #R - #L
            deltaBins           = deltaBins(:);

            %Get level and main level from block table
            block_info = fetch(behavior.TowersBlock & key, 'level', 'main_level');
            block_info = struct2table(block_info, 'AsArray', true);

            %Get array of main blocks and "guide" blocks
            mainBlocks = block_info(block_info.level == block_info.main_level,:);
            mainBlocks = mainBlocks.block;
            guidingBlocks = block_info(block_info.level ~= block_info.main_level,:);
            guidingBlocks = guidingBlocks.block;

            %Get all trials info
            trial_info = fetch(behavior.TowersBlockTrial & key, 'choice', 'cue_presence_left', 'cue_presence_right');

            if isempty(trial_info)
                return
            end

            trial_info = struct2table(trial_info, 'AsArray', true);

            %Transform cue and choice to numeric arrays (instead of cells)
            if ~iscell(trial_info.cue_presence_left)
                trial_info.cue_presence_left = num2cell(trial_info.cue_presence_left);
            end
            if ~iscell(trial_info.cue_presence_right)
                trial_info.cue_presence_right = num2cell(trial_info.cue_presence_right);
            end
            trial_info.num_towers_l = cellfun(@sum, trial_info.cue_presence_left);
            trial_info.num_towers_r = cellfun(@sum, trial_info.cue_presence_right);

            trial_info.choice = double(cellfun(@Choice,  trial_info.choice));

            %For each of the kind of level types:
            blocks_types = {'main', 'guiding'};
            blocks = {mainBlocks, guidingBlocks};
            for iblocks = 1:length(blocks)

                if size(blocks{iblocks}, 1)
                    %Filter corresponding trials
                    ac_trial_info = trial_info(ismember(trial_info.block,blocks{iblocks}),:);

                    %Fit and insert results
                    fit_results = behavior.utils.psychFit(deltaBins, ac_trial_info.num_towers_r, ...
                        ac_trial_info.num_towers_l, ac_trial_info.choice);

                    f = fieldnames(fit_results);

                    key_subtype = key;
                    for i = 1:length(f)
                        key_subtype.(strcat('blocks_', f{i})) = fit_results.(f{i});
                    end
                    key_subtype.blocks_type = blocks_types{iblocks};
                    self.insert(key_subtype)
                end
            end
        end
    end
end
