%% Analyse: Extract ERP for left and right no-stop trials
% Set parameters
analysis_window = [-100:0];

%% Extract: Mean amplitude during goal directed
for session_i = 1:29
    mean_EEG_left_AD02(session_i,1)  = nanmean(EEG_saccade_left{2}(session_i,analysis_window+1000));
    mean_EEG_right_AD02(session_i,1) = nanmean(EEG_saccade_right{2}(session_i,analysis_window+1000));

    mean_EEG_left_AD03(session_i,1)  = nanmean(EEG_saccade_left{3}(session_i,analysis_window+1000));
    mean_EEG_right_AD03(session_i,1) = nanmean(EEG_saccade_right{3}(session_i,analysis_window+1000));
    
    label_goal{session_i} = '1_goaldirected';
    
end

for session_i = 1:29
    mean_EEG_left_AD02_iti(session_i,1)  = nanmean(EEG_saccade_left_iti{2}(session_i,analysis_window+1000));
    mean_EEG_right_AD02_iti(session_i,1) = nanmean(EEG_saccade_right_iti{2}(session_i,analysis_window+1000));

    mean_EEG_left_AD03_iti(session_i,1)  = nanmean(EEG_saccade_left_iti{3}(session_i,analysis_window+1000));
    mean_EEG_right_AD03_iti(session_i,1) = nanmean(EEG_saccade_right_iti{3}(session_i,analysis_window+1000));
    
    label_iti{session_i} = '2_nongoaldirected';
    
end

%% Figure: Bar chart of mean amplitudes

% Data organization
data_in = [];
data_in = [mean_EEG_left_AD02; mean_EEG_right_AD03; mean_EEG_left_AD03_iti; mean_EEG_right_AD02_iti];
condition_label = [label_goal,label_goal,label_iti,label_iti]';

% GRAMM Setup
mean_goal_nongoal_amplitude(1,1) = gramm('x',condition_label,'y',data_in,'color',condition_label);
mean_goal_nongoal_amplitude(1,1).stat_summary('geom',{'edge_bar','black_errorbar'}); 
mean_goal_nongoal_amplitude(1,1).geom_jitter('alpha',0.2);

% Figure generation
mean_goal_nongoal_amplitude_out = figure('Renderer', 'painters', 'Position', [100 100 400 250]);
mean_goal_nongoal_amplitude.draw();

% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','mean_goal_nongoal_amplitude.pdf');
set(mean_goal_nongoal_amplitude_out,'PaperSize',[20 10]); %set the paper size to what you want
print(mean_goal_nongoal_amplitude_out,filename,'-dpdf') % then print it
close(mean_goal_nongoal_amplitude_out)
