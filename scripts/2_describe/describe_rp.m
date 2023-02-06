
%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
EEG_saccade_left = [];
EEG_saccade_right = [];

% For each session
for session = 1:29
    % Find the lateral channels
    for ch_index = 2:3
        
        channel = channel_list{ch_index};
        
        EEG_target_left{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_target_right{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));
        
        EEG_saccade_left{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_saccade_right{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));

    end
end


%% Figure: Population EEG for left/right target

for session = 1:29
    plot_EEG_left_A(session,:)  = EEG_saccade_left{2}(session,:);
    plot_EEG_right_A(session,:) = EEG_saccade_right{2}(session,:);
    
    plot_EEG_left_B(session,:)  = EEG_saccade_left{3}(session,:);
    plot_EEG_right_B(session,:) = EEG_saccade_right{3}(session,:);
    
end

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);
input_sdf_left_B = num2cell(plot_EEG_left_B, 2);
input_sdf_right_B = num2cell(plot_EEG_right_B, 2);

xlim_input = [-600 200];
ylim_input = [-10 10];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
time_electrode_AUC(1,1).stat_summary();
time_electrode_AUC(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

time_electrode_AUC(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
time_electrode_AUC(2,1).stat_summary();
time_electrode_AUC(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
time_electrode_AUC(2,1).facet_grid([],monkey_label);

time_electrode_AUC(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
time_electrode_AUC(1,2).stat_summary();
time_electrode_AUC(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

time_electrode_AUC(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
time_electrode_AUC(2,2).stat_summary();
time_electrode_AUC(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
time_electrode_AUC(2,2).facet_grid([],monkey_label);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 1500 800]);
time_electrode_AUC.draw();

% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_rp.pdf');
set(RP_A_figure_out,'PaperSize',[20 10]); %set the paper size to what you want
print(RP_A_figure_out,filename,'-dpdf') % then print it
close(RP_A_figure_out)

clear RP_A_figure input_sdf_* plot_EEG_*


%% Figure: Plot heatmap of trial-by-trial activity for each lateral electrode and for L/R trials
% Session 1 and 2 are nice examples, later ones still show effect but a
% little noisier

example_session_i = 1;

norm_window = [-600:0];
plot_window = [-600:100];

session_rt = executiveBeh.TrialEventTimes_Overall{example_session_i}(:,4)-...
    executiveBeh.TrialEventTimes_Overall{example_session_i}(:,2);
left_rt = session_rt(executiveBeh.ttx.GO_Left{example_session_i});
right_rt = session_rt(executiveBeh.ttx.GO_Right{example_session_i});

[~,left_rt_order] = sort(left_rt,'ascend');
[~,right_rt_order] = sort(right_rt,'ascend');

trl_norm_erp.AD02.Left = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,2}(executiveBeh.ttx.GO_Left{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD02.Right = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,2}(executiveBeh.ttx.GO_Right{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD03.Left = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,3}(executiveBeh.ttx.GO_Left{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD03.Right = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,3}(executiveBeh.ttx.GO_Right{example_session_i},:),...
    norm_window+1000);

example_session_heatmap = figure('Renderer', 'painters', 'Position', [100 100 1200 800]);
subplot(2,2,1); hold on
imagesc('XData',plot_window,...
    'YData',1:length(executiveBeh.ttx.GO_Left{example_session_i}),...
    'CData',trl_norm_erp.AD02.Left(left_rt_order,plot_window+1000))
plot(-left_rt(left_rt_order),1:length(executiveBeh.ttx.GO_Left{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(executiveBeh.ttx.GO_Left{example_session_i})])
colormap(red_blue); caxis([-1 1])
ylabel('Left saccade trials'); title('AD02')
colorbar('EastOutside')

subplot(2,2,2); hold on
imagesc('XData',plot_window,...
    'YData',1:length(executiveBeh.ttx.GO_Left{example_session_i}),...
    'CData',trl_norm_erp.AD03.Left(left_rt_order,plot_window+1000))
plot(-left_rt(left_rt_order),1:length(executiveBeh.ttx.GO_Left{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(executiveBeh.ttx.GO_Left{example_session_i})])
colormap(red_blue); caxis([-1 1]); title('AD03')
colorbar('EastOutside')

subplot(2,2,3); hold on
imagesc('XData',plot_window,...
    'YData',1:length(executiveBeh.ttx.GO_Right{example_session_i}),...
    'CData',trl_norm_erp.AD02.Right(right_rt_order,plot_window+1000))
plot(-right_rt(right_rt_order),1:length(executiveBeh.ttx.GO_Right{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(executiveBeh.ttx.GO_Right{example_session_i})])
colormap(red_blue); caxis([-1 1])
xlabel('Time from Saccade (ms)'); ylabel('Right saccade trials')
colorbar('EastOutside')

subplot(2,2,4); hold on
imagesc('XData',plot_window,...
    'YData',1:length(executiveBeh.ttx.GO_Right{example_session_i}),...
    'CData',trl_norm_erp.AD03.Right(right_rt_order,plot_window+1000))
plot(-right_rt(right_rt_order),1:length(executiveBeh.ttx.GO_Right{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(executiveBeh.ttx.GO_Right{example_session_i})])
colormap(red_blue); caxis([-1 1])
xlabel('Time from Saccade (ms)');
colorbar('EastOutside')


% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','example_session_heatmap.pdf');
set(example_session_heatmap,'PaperSize',[20 10]); %set the paper size to what you want
print(example_session_heatmap,filename,'-dpdf') % then print it
close(example_session_heatmap)

clear session_rt left_rt* right_rt* trl_norm_erp


%% Analysis: Windowed ROC analysis

for session_i = 1:29
    timewin = [-100:0]+1000;
    
    clear signal_AD*
    signal_AD02_left = nanmean(EEG_signal.saccade{session_i,2}(executiveBeh.ttx.GO_Left{session_i},timewin),2);
    signal_AD02_right = nanmean(EEG_signal.saccade{session_i,2}(executiveBeh.ttx.GO_Right{session_i},timewin),2);

    signal_AD03_left = nanmean(EEG_signal.saccade{session_i,3}(executiveBeh.ttx.GO_Left{session_i},timewin),2);
    signal_AD03_right = nanmean(EEG_signal.saccade{session_i,3}(executiveBeh.ttx.GO_Right{session_i},timewin),2);
    
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


plot_auc_electrode_out = figure('Renderer', 'painters', 'Position', [100 100 600 800]);
plot_auc_electrode.draw();


% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','AUC_ROC_Basic.pdf');
set(plot_auc_electrode_out,'PaperSize',[20 10]); %set the paper size to what you want
print(plot_auc_electrode_out,filename,'-dpdf') % then print it
close(plot_auc_electrode_out)


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

% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,1)=gramm('x',timewins.sdf,'y',[ROC_time_AD02;ROC_time_AD03],'color',labels_value);
time_electrode_AUC(1,1).stat_summary();
time_electrode_AUC(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,1).set_names('x','Time from Saccade (ms)','y','AUC');

time_electrode_AUC_out = figure('Renderer', 'painters', 'Position', [100 100 500 500]);
time_electrode_AUC.draw();

% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','AUC_ROC_time.pdf');
set(time_electrode_AUC_out,'PaperSize',[20 10]); %set the paper size to what you want
print(time_electrode_AUC_out,filename,'-dpdf') % then print it
close(time_electrode_AUC_out)

