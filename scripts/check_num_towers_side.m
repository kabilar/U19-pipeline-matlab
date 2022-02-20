
close all

date_min = 'session_date > "2016-01-01" and level >= 11';

all_sessions = fetch((behavior.TowersSession * acquisition.Session) & date_min, '*');

wrong_per = zeros(1, length(all_sessions));
really_wrong_per = zeros(1, length(all_sessions));

for i=1:length(all_sessions)
    
    wrong_num_total = 0;
    really_wrong_num_total = 0;
    for j=1:2
    
        idx_type_trial = find(all_sessions(i).rewarded_side == j);
        left_towers_type = all_sessions(i).num_towers_l(idx_type_trial);
        right_towers_type = all_sessions(i).num_towers_r(idx_type_trial);

        if j==1
            idx_wrong = find(right_towers_type == left_towers_type);
            idx_really_wrong = find(right_towers_type > left_towers_type);
        elseif j == 2
            idx_wrong = find(left_towers_type == right_towers_type);
            idx_really_wrong = find(left_towers_type > right_towers_type);
        end
        
        wrong_num_total = wrong_num_total +  length(idx_wrong);
        really_wrong_num_total = really_wrong_num_total + length(idx_really_wrong);

    end
    
    wrong_per(i) =        wrong_num_total*100 / length(all_sessions(i).rewarded_side);
    really_wrong_per(i) = really_wrong_num_total*100 / length(all_sessions(i).rewarded_side);
    
    
end

idx_wrong = find(wrong_per > 0 & wrong_per < 10);

total_sessions_wrong        = length(idx_wrong)*100 / length(wrong_per);

idx = find(really_wrong_per > 0 & really_wrong_per < 10);

total_sessions_really_wrong = length(idx)*100 / length(really_wrong_per);


figure
histogram(wrong_per, 'BinWidth',1,'Normalization', 'probability')

figure
histogram(really_wrong_per, 'BinWidth',1,'Normalization', 'probability')

