%% Analysis: Windowed ROC analysis

for session_i = 1:29
    timewin = [-100:0]+1000;

    clear signal_AD*
    signal_AD02_left = nanmean(EEG_signal.saccade{session_i,2}(ttx_matched.left{session_i},timewin),2);
    signal_AD02_right = nanmean(EEG_signal.saccade{session_i,2}(ttx_matched.right{session_i},timewin),2);

    signal_AD03_left = nanmean(EEG_signal.saccade{session_i,3}(ttx_matched.left{session_i},timewin),2);
    signal_AD03_right = nanmean(EEG_signal.saccade{session_i,3}(ttx_matched.right{session_i},timewin),2);

    clear ROC_temp*
    ROC_temp_AD02 = roc_curve(signal_AD02_right, signal_AD02_left);
    ROC_temp_AD03 = roc_curve(signal_AD03_left, signal_AD03_right);

    filename_i = FileNames(session_i);
    session = session_i;
    monkey = executiveBeh.nhpSessions.monkeyNameLabel(session_i);
    ROC_AD02_auc = ROC_temp_AD02.param.AROC;
    ROC_AD02_curve = {ROC_temp_AD02.curve};
    ROC_AD03_auc = ROC_temp_AD03.param.AROC;
    ROC_AD03_curve = {ROC_temp_AD03.curve};

    ROC_analysis(session_i,:) = table(filename_i, session,...
        monkey, ROC_AD02_auc, ROC_AD02_curve,...
        ROC_AD03_auc, ROC_AD03_curve);

end


%% Figure: Windowed ROC analysis
clear electrode_label motor_auc plot_auc_electrode
electrode_label = [repmat({'AD02'},29,1);repmat({'AD03'},29,1)];

motor_auc = [ROC_analysis.ROC_AD02_auc; ROC_analysis.ROC_AD03_auc];
plot_auc_electrode(1,1) = gramm('x',electrode_label,'y',motor_auc,'color',electrode_label);
plot_auc_electrode(2,1) = gramm('x',electrode_label,'y',motor_auc,'color',electrode_label);

plot_auc_electrode(1,1).stat_boxplot();
plot_auc_electrode(1,1).geom_jitter('alpha',0.7);

plot_auc_electrode(2,1).stat_boxplot();
plot_auc_electrode(2,1).geom_jitter('alpha',0.7);

plot_auc_electrode(2,1).facet_grid([],[ROC_analysis.monkey; ROC_analysis.monkey]);

plot_auc_electrode(1,1).axe_property('YLim',[0.5 1]);
plot_auc_electrode(2,1).axe_property('YLim',[0.5 1]);


plot_auc_electrode_out = figure('Renderer', 'painters', 'Position', [100 100 300 400]);
plot_auc_electrode.draw();


% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','AUC_ROC_Basic.pdf');
set(plot_auc_electrode_out,'PaperSize',[20 10]); %set the paper size to what you want
print(plot_auc_electrode_out,filename,'-dpdf') % then print it
close(plot_auc_electrode_out)
