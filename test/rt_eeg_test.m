%% Figure: Plot heatmap of trial-by-trial activity for each lateral electrode and for L/R trials
% Session 1 and 2 are nice examples, later ones still show effect but a
% little noisier

for session_i = 1:29

clear rt_trials session_rt left_rt* right_rt* rt_trials

session_rt = executiveBeh.TrialEventTimes_Overall{session_i}(:,4)-...
    executiveBeh.TrialEventTimes_Overall{session_i}(:,2);
left_rt = session_rt(ttx_matched.left{session_i});
right_rt = session_rt(ttx_matched.right{session_i});

[~,left_rt_order] = sort(left_rt,'ascend');
[~,right_rt_order] = sort(right_rt,'ascend');

[~,~,left_rt_bin] = histcounts(left_rt,3);
[~,~,right_rt_bin] = histcounts(right_rt,3);

rt_trials.left.fast = ttx_matched.left{session_i}(left_rt_bin == 1);
rt_trials.left.mid = ttx_matched.left{session_i}(left_rt_bin == 2);
rt_trials.left.slow = ttx_matched.left{session_i}(left_rt_bin == 3);
rt_trials.right.fast = ttx_matched.right{session_i}(right_rt_bin == 1);
rt_trials.right.mid = ttx_matched.right{session_i}(right_rt_bin == 2);
rt_trials.right.slow = ttx_matched.right{session_i}(right_rt_bin == 3);

test_fast_ADO2(session_i,:) = nanmean(EEG_signal.target{session_i,2}(rt_trials.left.fast,:));
test_mid_AD02(session_i,:) = nanmean(EEG_signal.target{session_i,2}(rt_trials.left.mid,:));
test_slow_AD02(session_i,:) = nanmean(EEG_signal.target{session_i,2}(rt_trials.left.slow,:));

test_fast_ADO3(session_i,:) = nanmean(EEG_signal.target{session_i,3}(rt_trials.right.fast,:));
test_mid_AD03(session_i,:) = nanmean(EEG_signal.target{session_i,3}(rt_trials.right.mid,:));
test_slow_AD03(session_i,:) = nanmean(EEG_signal.target{session_i,3}(rt_trials.right.slow,:));

end

%% Figure: Temporal ROC analysis
test_fast_AD02_plot = num2cell(test_fast_ADO2, 2);
test_mid_AD02_plot = num2cell(test_mid_AD02, 2);
test_slow_AD02_plot = num2cell(test_slow_AD02, 2);

test_fast_AD03_plot = num2cell(test_fast_ADO3, 2);
test_mid_AD03_plot = num2cell(test_mid_AD03, 2);
test_slow_AD03_plot = num2cell(test_slow_AD03, 2);

xlim_input = [-100 600];
% ylim_input = [0.0 1.0];
timewins.sdf = -999:2000;

labels_value = [repmat({'Fast'},length(test_fast_AD02_plot),1);repmat({'Mid'},length(test_mid_AD02_plot),1);repmat({'Slow'},length(test_mid_AD02_plot),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,3,1)];

% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,1)=gramm('x',timewins.sdf,'y',[test_fast_AD02_plot;test_mid_AD02_plot;test_slow_AD02_plot],'color',labels_value);
time_electrode_AUC(1,1).stat_summary();
time_electrode_AUC(1,1).axe_property('XLim',xlim_input,'YLim',[-6 6]);
time_electrode_AUC(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');



% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,2)=gramm('x',timewins.sdf,'y',[test_fast_AD03_plot;test_mid_AD03_plot;test_slow_AD03_plot],'color',labels_value);
time_electrode_AUC(1,2).stat_summary();
time_electrode_AUC(1,2).axe_property('XLim',xlim_input,'YLim',[-6 6]);
time_electrode_AUC(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');



time_electrode_AUC_out = figure('Renderer', 'painters', 'Position', [100 100 1000 500]);
time_electrode_AUC.draw();
