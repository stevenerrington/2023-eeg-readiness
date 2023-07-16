%% Figure: Plot heatmap of trial-by-trial activity for each lateral electrode and for L/R trials
% Session 1 and 2 are nice examples, later ones still show effect but a
% little noisier

for session_i = 1:29
    
    clear rt_trials session_rt left_rt* right_rt* rt_trials
    
    session_rt = executiveBeh.TrialEventTimes_Overall{session_i}(:,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(:,2);
    left_rt = session_rt(ttx_matched.left{session_i});
    right_rt = session_rt(ttx_matched.right{session_i});
    
    rt_trials.left.fast = ttx_matched.left{session_i}(find(left_rt<(quantile(left_rt,0.33))));
    rt_trials.left.slow = ttx_matched.left{session_i}(find(left_rt>(quantile(left_rt,0.66))));
    rt_trials.right.fast = ttx_matched.right{session_i}(find(right_rt<(quantile(right_rt,0.33))));
    rt_trials.right.slow = ttx_matched.right{session_i}(find(right_rt>(quantile(right_rt,0.66))));
    
    target_fast_AD02(session_i,:) = nanmean(EEG_signal.target{session_i,2}(rt_trials.left.fast,:));
    target_slow_AD02(session_i,:) = nanmean(EEG_signal.target{session_i,2}(rt_trials.left.slow,:));
    
    saccade_fast_AD02(session_i,:) = nanmean(EEG_signal.saccade{session_i,2}(rt_trials.left.fast,:));
    saccade_slow_AD02(session_i,:) = nanmean(EEG_signal.saccade{session_i,2}(rt_trials.left.slow,:));
    
    target_fast_AD03(session_i,:) = nanmean(EEG_signal.target{session_i,3}(rt_trials.right.fast,:));
    target_slow_AD03(session_i,:) = nanmean(EEG_signal.target{session_i,3}(rt_trials.right.slow,:));
    
    saccade_fast_AD03(session_i,:) = nanmean(EEG_signal.saccade{session_i,3}(rt_trials.right.fast,:));
    saccade_slow_AD03(session_i,:) = nanmean(EEG_signal.saccade{session_i,3}(rt_trials.right.slow,:));
    
    
    
    target_fast_AD02_average(session_i,:) = mean(nanmean(EEG_signal.target{session_i,2}(rt_trials.left.fast,1001+[50:100])));
    target_slow_AD02_average(session_i,:) = mean(nanmean(EEG_signal.target{session_i,2}(rt_trials.left.slow,1001+[50:100])));
    
    saccade_fast_AD02_average(session_i,:) = mean(nanmean(EEG_signal.saccade{session_i,2}(rt_trials.left.fast,1001+[-200:0])));
    saccade_slow_AD02_average(session_i,:) = mean(nanmean(EEG_signal.saccade{session_i,2}(rt_trials.left.slow,1001+[-200:0])));
    
    target_fast_AD03_average(session_i,:) = mean(nanmean(EEG_signal.target{session_i,3}(rt_trials.right.fast,1001+[50:100])));
    target_slow_AD03_average(session_i,:) = mean(nanmean(EEG_signal.target{session_i,3}(rt_trials.right.slow,1001+[50:100])));
    
    saccade_fast_AD03_average(session_i,:) = mean(nanmean(EEG_signal.saccade{session_i,3}(rt_trials.right.fast,1001+[-200:0])));
    saccade_slow_AD03_average(session_i,:) = mean(nanmean(EEG_signal.saccade{session_i,3}(rt_trials.right.slow,1001+[-200:0])));
    
end

%% Figure: Temporal ROC analysis
target_fast_AD02_plot = num2cell(target_fast_AD02, 2); target_slow_AD02_plot = num2cell(target_slow_AD02, 2);
saccade_fast_AD02_plot = num2cell(saccade_fast_AD02, 2); saccade_slow_AD02_plot = num2cell(saccade_slow_AD02, 2);
target_fast_AD03_plot = num2cell(target_fast_AD03, 2); target_slow_AD03_plot = num2cell(target_slow_AD03, 2);
saccade_fast_AD03_plot = num2cell(saccade_fast_AD03, 2); saccade_slow_AD03_plot = num2cell(saccade_slow_AD03, 2);

xlim_input_target = [-100 300]; xlim_input_saccade = [-300 100];

timewins.sdf = -999:2000;

labels_value = [repmat({'Fast'},length(saccade_fast_AD02_plot),1);repmat({'Slow'},length(saccade_slow_AD02_plot),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

average_erp_target_AD02 = [target_fast_AD02_average; target_slow_AD02_average];
average_erp_target_AD03 = [target_fast_AD03_average; target_slow_AD03_average];
average_erp_saccade_AD02 = [saccade_fast_AD02_average; saccade_slow_AD02_average];
average_erp_saccade_AD03 = [saccade_fast_AD03_average; saccade_slow_AD03_average];

bar_width = 1.5;

% Produce the figure, collapsed across all monkeys
clear rt_figure
% Target onset: AD02
rt_figure(1,1)=gramm('x',timewins.sdf,'y',[target_fast_AD02_plot;target_slow_AD02_plot],'color',labels_value);
rt_figure(1,1).stat_summary();
rt_figure(1,1).axe_property('XLim',xlim_input_target,'YLim',[-0.008 0.008]);
rt_figure(1,1).set_names('x','Time from Target (ms)','y','EEG (uV)');
rt_figure(1,1).no_legend;

% Saccade onset: AD02
rt_figure(1,2)=gramm('x',timewins.sdf,'y',[saccade_fast_AD02_plot;saccade_slow_AD02_plot],'color',labels_value);
rt_figure(1,2).stat_summary();
rt_figure(1,2).axe_property('XLim',xlim_input_saccade,'YLim',[-0.008 0.008]);
rt_figure(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
rt_figure(1,2).no_legend;

% Average (target)
rt_figure(1,3)=gramm('x',labels_value,'y',[average_erp_target_AD02],'color',labels_value);
rt_figure(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
rt_figure(1,3).axe_property('YLim',[0 0.005]);
rt_figure(1,3).set_names('x','','y','EEG (uV)');
rt_figure(1,3).no_legend;

% Average (saccade)
rt_figure(1,4)=gramm('x',labels_value,'y',[average_erp_saccade_AD02],'color',labels_value);
rt_figure(1,4).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
rt_figure(1,4).axe_property('YLim',[0 0.005]);
rt_figure(1,4).set_names('x','','y','EEG (uV)');
rt_figure(1,4).no_legend;

% Target onset: AD03
rt_figure(2,1)=gramm('x',timewins.sdf,'y',[target_fast_AD03_plot;target_slow_AD03_plot],'color',labels_value);
rt_figure(2,1).stat_summary();
rt_figure(2,1).axe_property('XLim',xlim_input_target,'YLim',[-0.008 0.008]);
rt_figure(2,1).set_names('x','Time from Target (ms)','y','EEG (uV)');
rt_figure(2,1).no_legend;

% Saccade onset: AD03
rt_figure(2,2)=gramm('x',timewins.sdf,'y',[saccade_fast_AD03_plot;saccade_slow_AD03_plot],'color',labels_value);
rt_figure(2,2).stat_summary();
rt_figure(2,2).axe_property('XLim',xlim_input_saccade,'YLim',[-0.008 0.008]);
rt_figure(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
rt_figure(2,2).no_legend;

% Average (target)
rt_figure(2,3)=gramm('x',labels_value,'y',[average_erp_target_AD03],'color',labels_value);
rt_figure(2,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
rt_figure(2,3).axe_property('YLim',[0 0.005]);
rt_figure(2,3).set_names('x','','y','EEG (uV)');
rt_figure(2,3).no_legend;

% Average (saccade)
rt_figure(2,4)=gramm('x',labels_value,'y',[average_erp_saccade_AD03],'color',labels_value);
rt_figure(2,4).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
rt_figure(2,4).axe_property('YLim',[0 0.005]);
rt_figure(2,4).set_names('x','','y','EEG (uV)');
rt_figure(2,4).no_legend;

% Layout >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Pre-CS: Raster, SDF, Fano (Example)
rt_figure(1,1).set_layout_options('Position',[0.1 0.7 0.25 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(1,2).set_layout_options('Position',[0.4 0.7 0.25 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(1,3).set_layout_options('Position',[0.7 0.7 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(1,4).set_layout_options('Position',[0.85 0.7 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(2,1).set_layout_options('Position',[0.1 0.25 0.25 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(2,2).set_layout_options('Position',[0.4 0.25 0.25 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(2,3).set_layout_options('Position',[0.7 0.25 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

rt_figure(2,4).set_layout_options('Position',[0.85 0.25 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);





rt_figure_out = figure('Renderer', 'painters', 'Position', [100 100 750 500]);
rt_figure.draw();
