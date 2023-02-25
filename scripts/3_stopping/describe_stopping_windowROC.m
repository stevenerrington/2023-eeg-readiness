%% Analysis: Windowed ROC analysis
ROC_analysis_stopping = table();

for session_i = 1:29
    timewin = 1000+[0:bayesianSSRT.ssrt_mean(session_i)];

    % Input EEG data
    clear signal_AD*
    signal_AD02_nostop_lm = EEG_latencyMatched_left_ns{2}(session_i,:);
    signal_AD02_canceled_lm = EEG_latencyMatched_left_c{2}(session_i,:);

    signal_AD03_nostop_lm = EEG_latencyMatched_right_ns{3}(session_i,:);
    signal_AD03_canceled_lm = EEG_latencyMatched_right_c{3}(session_i,:);

    signal_AD02_noncanc = EEG_stopping_left{2}(session_i,:);
    signal_AD02_canceled = EEG_stopping_left_nc{2}(session_i,:);

    signal_AD03_noncanc = EEG_stopping_right{3}(session_i,:);
    signal_AD03_canceled = EEG_stopping_right_nc{3}(session_i,:);
    
    
    % ROC analysis
    clear ROC_temp*
    ROC_temp_AD02_canc_nostop = roc_curve(signal_AD02_canceled_lm, signal_AD02_nostop_lm);
    ROC_temp_AD03_canc_nostop = roc_curve(signal_AD03_canceled_lm, signal_AD03_nostop_lm);

    ROC_temp_AD02_canc_noncanc = roc_curve(signal_AD02_canceled, signal_AD02_noncanc);
    ROC_temp_AD03_canc_noncanc = roc_curve(signal_AD03_canceled, signal_AD03_canceled);
    
    % Output ROC analysis
    filename_i = FileNames(session_i);
    session = session_i;
    monkey = executiveBeh.nhpSessions.monkeyNameLabel(session_i);
    ROC_AD02_auc_canc_nostop = ROC_temp_AD02_canc_nostop.param.AROC;
    ROC_AD02_curve_canc_nostop = {ROC_temp_AD02_canc_nostop.curve};
    ROC_AD03_auc_canc_nostop = ROC_temp_AD03_canc_nostop.param.AROC;
    ROC_AD03_curve_canc_nostop = {ROC_temp_AD03_canc_nostop.curve};

    ROC_AD02_auc_canc_noncanc = ROC_temp_AD02_canc_noncanc.param.AROC;
    ROC_AD02_curve_canc_noncanc = {ROC_temp_AD02_canc_noncanc.curve};
    ROC_AD03_auc_canc_noncanc = ROC_temp_AD03_canc_noncanc.param.AROC;
    ROC_AD03_curve_canc_noncanc = {ROC_temp_AD03_canc_noncanc.curve};

    ROC_analysis_stopping(session_i,:) = table(filename_i, session,...
        monkey, ROC_AD02_auc_canc_nostop, ROC_AD02_curve_canc_nostop,...
        ROC_AD03_auc_canc_nostop, ROC_AD03_curve_canc_nostop,...
        ROC_AD02_auc_canc_noncanc, ROC_AD02_curve_canc_noncanc,...
        ROC_AD03_auc_canc_noncanc, ROC_AD03_curve_canc_noncanc);

end


%% Figure: Windowed ROC analysis
clear electrode_label stopping_auc_* plot_auc_electrode
electrode_label = [repmat({'AD02'},29,1);repmat({'AD03'},29,1)];

stopping_auc_canc_noncanc = [ROC_analysis_stopping.ROC_AD02_auc_canc_noncanc; ROC_analysis_stopping.ROC_AD03_auc_canc_noncanc];
stopping_auc_canc_nostop = [ROC_analysis_stopping.ROC_AD02_auc_canc_nostop; ROC_analysis_stopping.ROC_AD03_auc_canc_nostop];

plot_auc_electrode(1,1) = gramm('x',electrode_label,'y',stopping_auc_canc_nostop,'color',electrode_label);
plot_auc_electrode(2,1) = gramm('x',electrode_label,'y',stopping_auc_canc_nostop,'color',electrode_label);
plot_auc_electrode(1,2) = gramm('x',electrode_label,'y',stopping_auc_canc_noncanc,'color',electrode_label);
plot_auc_electrode(2,2) = gramm('x',electrode_label,'y',stopping_auc_canc_noncanc,'color',electrode_label);

plot_auc_electrode(1,1).stat_boxplot(); plot_auc_electrode(1,1).geom_jitter('alpha',0.7);
plot_auc_electrode(1,2).stat_boxplot(); plot_auc_electrode(1,2).geom_jitter('alpha',0.7);
plot_auc_electrode(2,1).stat_boxplot(); plot_auc_electrode(2,1).geom_jitter('alpha',0.7);
plot_auc_electrode(2,2).stat_boxplot(); plot_auc_electrode(2,2).geom_jitter('alpha',0.7);

plot_auc_electrode(2,1).facet_grid([],[ROC_analysis_stopping.monkey; ROC_analysis_stopping.monkey]);
plot_auc_electrode(2,2).facet_grid([],[ROC_analysis_stopping.monkey; ROC_analysis_stopping.monkey]);

plot_auc_electrode(1,1).axe_property('YLim',[0.0 1]); plot_auc_electrode(2,1).axe_property('YLim',[0.0 1]);
plot_auc_electrode(1,2).axe_property('YLim',[0.0 1]); plot_auc_electrode(2,2).axe_property('YLim',[0.0 1]);

plot_auc_electrode_out = figure('Renderer', 'painters', 'Position', [100 100 600 400]);
plot_auc_electrode.draw();

%% Export: Save Figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','AUC_ROC_Stopping.pdf');
set(plot_auc_electrode_out,'PaperSize',[20 10]); %set the paper size to what you want
print(plot_auc_electrode_out,filename,'-dpdf') % then print it
close(plot_auc_electrode_out)