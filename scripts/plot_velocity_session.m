
function plot_velocity_session(trials)




mean_vel = zeros(1, length(trials));
std_vel = zeros(1, length(trials));
session_cell = cell(1, length(trials));
for i = 1:length(trials)
    
    i_arm_entry = trials(i).i_arm_entry;
    calc_vel = diff(trials(i).position(2:i_arm_entry,2))*120;
    mean_vel(i) = mean(calc_vel);
    std_vel(i) = 0;
    session_cell{i} = trials(i).session_date;
end

sessions = unique({trials.session_date});

mean_mean_vel = zeros(1, length(sessions));
min_mean_vel = zeros(1, length(sessions));
max_mean_vel = zeros(1, length(sessions));
for j = 1:length(sessions)
    current_session = sessions{j};
    
    idx = find(ismember(session_cell, current_session));
    mean_mean_vel(j) =  mean(mean_vel(idx));
    min_mean_vel(j)  =  min(mean_vel(idx));
    max_mean_vel(j)  =  min(mean_vel(idx));
    
end
    
 
close all
f = figure;
set(f, 'Units', 'normalized', 'Position', [0 0 1 1])


plot(1:length(sessions),mean_mean_vel, 'o')
hold on
errorbar(1:length(sessions), mean_mean_vel, mean_mean_vel-min_mean_vel, max_mean_vel-mean_mean_vel);
set(gcf, 'color', 'w')

ylabel('mean velocity per trial (cm/s) min-max range', 'Fontsize', 14)
xlabel('Date', 'Fontsize', 14)
title(['Velocity for: ', unique({trials.subject_fullname})], 'FontSize', 16, 'Interpreter', 'none')

xticks(1:length(sessions))
xticklabels(sessions)
xtickangle(45)
