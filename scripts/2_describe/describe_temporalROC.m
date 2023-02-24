
%% Analysis: Temporal ROC analysis
bin_step = 10;

bin_window = -600:bin_step:200;

warning off
for session_i = 1:29

    for time_i = 1:length(bin_window)-1
        timewin = [bin_window(time_i):bin_window(time_i+1)]+1000;
        time(time_i) = median(timewin)-1000;


        clear signal_AD*
        signal_AD02_left = nanmean(EEG_signal.saccade{session_i,2}(executiveBeh.ttx.GO_Left{session_i},timewin),2);
        signal_AD02_right = nanmean(EEG_signal.saccade{session_i,2}(executiveBeh.ttx.GO_Right{session_i},timewin),2);

        signal_AD03_left = nanmean(EEG_signal.saccade{session_i,3}(executiveBeh.ttx.GO_Left{session_i},timewin),2);
        signal_AD03_right = nanmean(EEG_signal.saccade{session_i,3}(executiveBeh.ttx.GO_Right{session_i},timewin),2);

        clear ROC_temp*
        ROC_temp_AD02 = roc_curve(signal_AD02_right, signal_AD02_left);
        ROC_temp_AD03 = roc_curve(signal_AD03_left, signal_AD03_right);

        ROC_AD02_auc(session_i,time_i) = ROC_temp_AD02.param.AROC;
        ROC_AD03_auc(session_i,time_i) = ROC_temp_AD03.param.AROC;

    end

end

%% Figure: Temporal ROC analysis
ROC_time_AD02 = num2cell(ROC_AD02_auc, 2);
ROC_time_AD03 = num2cell(ROC_AD03_auc, 2);

xlim_input = [-600 200];
ylim_input = [0.0 1.0];
timewins.sdf = time;

labels_value = [repmat({'AD02'},length(ROC_time_AD02),1);repmat({'AD03'},length(ROC_time_AD03),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

clear time_electrode_AUC
% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,1)=gramm('x',timewins.sdf,'y',[ROC_time_AD02;ROC_time_AD03],'color',labels_value);
time_electrode_AUC(1,1).stat_summary();
time_electrode_AUC(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,1).set_names('x','Time from Saccade (ms)','y','AUC');
time_electrode_AUC(1,1).geom_hline('yintercept',0.5);

time_electrode_AUC_out = figure('Renderer', 'painters', 'Position', [100 100 500 200]);
time_electrode_AUC.draw;

% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','AUC_ROC_time.pdf');
set(time_electrode_AUC_out,'PaperSize',[20 10]); %set the paper size to what you want
print(time_electrode_AUC_out,filename,'-dpdf') % then print it
close(time_electrode_AUC_out)

