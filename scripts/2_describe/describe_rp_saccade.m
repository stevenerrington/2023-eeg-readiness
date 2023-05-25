%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
EEG_saccade_left = [];
EEG_saccade_right = [];
clear colormap
% For each session
for session = 1:29
    % Find the lateral channels
    for ch_index = 1:4

        channel = channel_list{ch_index};

        EEG_target_left{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(ttx_matched.left{session},:));
        EEG_target_right{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(ttx_matched.right{session},:));

        EEG_saccade_left{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(ttx_matched.left{session},:));
        EEG_saccade_right{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(ttx_matched.right{session},:));

    end
end


%% Figure: Saccade-aligned Population EEG for left/right target

for session = 1:29
    plot_EEG_left_A(session,:)  = EEG_saccade_left{2}(session,:);
    plot_EEG_right_A(session,:) = EEG_saccade_right{2}(session,:);

    plot_EEG_left_B(session,:)  = EEG_saccade_left{3}(session,:);
    plot_EEG_right_B(session,:) = EEG_saccade_right{3}(session,:);
    
    plot_EEG_left_C(session,:)  = EEG_saccade_left{1}(session,:);
    plot_EEG_right_C(session,:) = EEG_saccade_right{1}(session,:);
    
    plot_EEG_left_D(session,:)  = EEG_saccade_left{4}(session,:);
    plot_EEG_right_D(session,:) = EEG_saccade_right{4}(session,:);

end

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);
input_sdf_left_B = num2cell(plot_EEG_left_B, 2);
input_sdf_right_B = num2cell(plot_EEG_right_B, 2);
input_sdf_left_C = num2cell(plot_EEG_left_C, 2);
input_sdf_right_C = num2cell(plot_EEG_right_C, 2);
input_sdf_left_D = num2cell(plot_EEG_left_D, 2);
input_sdf_right_D = num2cell(plot_EEG_right_D, 2);

xlim_input = [-600 200];
ylim_input = [-0.01 0.02];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
rp_grandaverage_erp(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_C;input_sdf_right_C],'color',labels_value);
rp_grandaverage_erp(1,2).stat_summary();
rp_grandaverage_erp(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_grandaverage_erp(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

rp_grandaverage_erp(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
rp_grandaverage_erp(2,1).stat_summary();
rp_grandaverage_erp(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_grandaverage_erp(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

rp_grandaverage_erp(2,3)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
rp_grandaverage_erp(2,3).stat_summary();
rp_grandaverage_erp(2,3).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_grandaverage_erp(2,3).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

rp_grandaverage_erp(3,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_D;input_sdf_right_D],'color',labels_value);
rp_grandaverage_erp(3,2).stat_summary();
rp_grandaverage_erp(3,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_grandaverage_erp(3,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 1200 800]);
rp_grandaverage_erp.draw();

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
plot_window = [-600:200];

session_rt = executiveBeh.TrialEventTimes_Overall{example_session_i}(:,4)-...
    executiveBeh.TrialEventTimes_Overall{example_session_i}(:,2);
left_rt = session_rt(ttx_matched.left{example_session_i});
right_rt = session_rt(ttx_matched.right{example_session_i});

[~,left_rt_order] = sort(left_rt,'ascend');
[~,right_rt_order] = sort(right_rt,'ascend');

trl_norm_erp.AD02.Left = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,2}(ttx_matched.left{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD02.Right = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,2}(ttx_matched.right{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD03.Left = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,3}(ttx_matched.left{example_session_i},:),...
    norm_window+1000);
trl_norm_erp.AD03.Right = maxnorm_trl_signal(...
    EEG_signal.saccade{example_session_i,3}(ttx_matched.right{example_session_i},:),...
    norm_window+1000);

example_session_heatmap = figure('Renderer', 'painters', 'Position', [100 100 1200 800]);
subplot(2,2,1); hold on
imagesc('XData',plot_window,...
    'YData',1:length(ttx_matched.left{example_session_i}),...
    'CData',trl_norm_erp.AD02.Left(left_rt_order,plot_window+1000))
plot(-left_rt(left_rt_order),1:length(ttx_matched.left{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(ttx_matched.left{example_session_i})])
colormap(red_blue); caxis([-1 1])
ylabel('Left saccade trials'); title('AD02')
colorbar('EastOutside')

subplot(2,2,2); hold on
imagesc('XData',plot_window,...
    'YData',1:length(ttx_matched.left{example_session_i}),...
    'CData',trl_norm_erp.AD03.Left(left_rt_order,plot_window+1000))
plot(-left_rt(left_rt_order),1:length(ttx_matched.left{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(ttx_matched.left{example_session_i})])
colormap(red_blue); caxis([-1 1]); title('AD03')
colorbar('EastOutside')

subplot(2,2,3); hold on
imagesc('XData',plot_window,...
    'YData',1:length(ttx_matched.right{example_session_i}),...
    'CData',trl_norm_erp.AD02.Right(right_rt_order,plot_window+1000))
plot(-right_rt(right_rt_order),1:length(ttx_matched.right{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(ttx_matched.right{example_session_i})])
colormap(red_blue); caxis([-1 1])
xlabel('Time from Saccade (ms)'); ylabel('Right saccade trials')
colorbar('EastOutside')

subplot(2,2,4); hold on
imagesc('XData',plot_window,...
    'YData',1:length(ttx_matched.right{example_session_i}),...
    'CData',trl_norm_erp.AD03.Right(right_rt_order,plot_window+1000))
plot(-right_rt(right_rt_order),1:length(ttx_matched.right{example_session_i}),'k','LineWidth',2)
vline(0,'k')
xlim([plot_window(1) plot_window(end)]); ylim([1 length(ttx_matched.right{example_session_i})])
colormap(red_blue); caxis([-1 1])
xlabel('Time from Saccade (ms)');
colorbar('EastOutside')


% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','example_session_heatmap.pdf');
set(example_session_heatmap,'PaperSize',[20 10]); %set the paper size to what you want
print(example_session_heatmap,filename,'-dpdf') % then print it
close(example_session_heatmap)

clear session_rt left_rt* right_rt* trl_norm_erp

%% Analyse: Extract mean ERP amplitude for left and right no-stop trials
% Set parameters
analysis_window = [-100:0];

for session_i = 1:29
    mean_EEG_left_AD02(session_i,1)  = nanmean(EEG_saccade_left{2}(session_i,analysis_window+1000));
    mean_EEG_right_AD02(session_i,1) = nanmean(EEG_saccade_right{2}(session_i,analysis_window+1000));

    mean_EEG_left_AD03(session_i,1)  = nanmean(EEG_saccade_left{3}(session_i,analysis_window+1000));
    mean_EEG_right_AD03(session_i,1) = nanmean(EEG_saccade_right{3}(session_i,analysis_window+1000));
        
end

%% Figure: Bar chart of mean amplitudes

% Data organization
data_in = [];
data_in = [mean_EEG_left_AD02; mean_EEG_right_AD03; mean_EEG_right_AD02; mean_EEG_left_AD03];
electrode_label = [repmat({'1_AD02'},29,1); repmat({'2_AD03'},29,1); repmat({'1_AD02'},29,1); repmat({'2_AD03'},29,1)] ;
saccade_label = [repmat({'1_left'},29,1); repmat({'2_right'},29,1); repmat({'2_right'},29,1); repmat({'1_left'},29,1)] ;

% GRAMM Setup
mean_electrode_amplitude(1,1) = gramm('x',electrode_label,'y',data_in,'color',saccade_label);
mean_electrode_amplitude(1,1).geom_jitter('alpha',0.2);
mean_electrode_amplitude(1,1).stat_summary('geom',{'point','line','errorbar'}); 
mean_electrode_amplitude(1,1).geom_hline('yintercept',0);

% Figure generation
mean_electrode_amplitude_out = figure('Renderer', 'painters', 'Position', [100 100 400 300]);
mean_electrode_amplitude.draw();

% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','mean_electrode_amplitude.pdf');
set(mean_electrode_amplitude_out,'PaperSize',[20 10]); %set the paper size to what you want
print(mean_electrode_amplitude_out,filename,'-dpdf') % then print it
close(mean_electrode_amplitude_out)

%% Analysis: 2 x 2 repeated measures ANOVA
anova_table = table...
    (mean_EEG_left_AD02,mean_EEG_right_AD02,mean_EEG_left_AD03,mean_EEG_right_AD03,...
    'VariableNames',{'F3_L','F3_R','F4_L','F4_R'});

writetable(anova_table,fullfile(dirs.root,'results','eeg_uv_outtable.csv'),'WriteRowNames',true)


% electrode x laterality anova in JASP.




