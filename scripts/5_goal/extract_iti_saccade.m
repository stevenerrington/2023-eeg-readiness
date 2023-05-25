
%% Extract: find saccades within the inter-trial interval matching a given criteria.

% Criteria ----------------
sacc_amp_cutoff = 15;
sacc_dir_range_right = [320 45];
sacc_dir_range_left = [135 225];
    
% Extraction ---------------
if exist(fullfile(dirs.root,'data','ttx_iti_saccade.mat')) == 2
    load(fullfile(dirs.root,'data','ttx_iti_saccade.mat'));
else
    ttx_itiSaccade = [];
    
    % For each session
    for session_i = 1:29
        clc; fprintf('Extracting data from %s... | file %i of %i \n',FileNames{session_i}, session_i, 29);
        
        % Load the raw data file
        data_in = load(fullfile(dirs.raw_data,FileNames{session_i}));
        
        
        % For each trial
        nTrls = length(data_in.TrialStart_); clear iti_saccade_time
        
        for trl_i = 1:nTrls
            
            % Find saccades meeting the criteria
            iti_sacc_flag = find(...
                data_in.SaccBegin(trl_i,:) > data_in.Reward_(trl_i)+300 &...
                data_in.SaccBegin(trl_i,:) < data_in.Reward_(trl_i)+1200 &... % Occuring within ITI
                data_in.SaccAmplitude(trl_i,:) > sacc_amp_cutoff &... % Greater than a given amplitude
                ((data_in.SaccDirection(trl_i,:) > sacc_dir_range_left(1) &... ... % Greater than a given amplitude
                data_in.SaccDirection(trl_i,:) < sacc_dir_range_left(2)) |...
                (data_in.SaccDirection(trl_i,:) > sacc_dir_range_right(1) | ... ... % Greater than a given amplitude
                data_in.SaccDirection(trl_i,:) < sacc_dir_range_right(2))),1);
            
           

            % And output their details
            if ~isempty(iti_sacc_flag)
                iti_saccade_time(trl_i,1) = trl_i;
                iti_saccade_time(trl_i,2) = data_in.SaccBegin(trl_i,iti_sacc_flag)+data_in.TrialStart_(trl_i);
                iti_saccade_time(trl_i,3) = data_in.SaccDirection(trl_i,iti_sacc_flag);
                iti_saccade_time(trl_i,4) = data_in.SaccAmplitude(trl_i,iti_sacc_flag);
                iti_saccade_time(trl_i,5) = data_in.SaccBegin(trl_i,iti_sacc_flag-1)+data_in.TrialStart_(trl_i);
                
            else
                iti_saccade_time(trl_i,1) = trl_i;
                iti_saccade_time(trl_i,2) = NaN;
                iti_saccade_time(trl_i,3) = NaN;
                iti_saccade_time(trl_i,4) = NaN;
                iti_saccade_time(trl_i,5) = NaN;

            end
            
        end
        
        % Save the output for each session to a cell array
        ttx_itiSaccade{session_i,1} = iti_saccade_time;
        
    end
    
    % Extract: stratify trial types >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    % For each trial
    
    for session_i = 1:29
        
        % Find leftward and rightward saccades
        left_saccade_idx = []; right_saccade_idx = [];
        left_saccade_idx = find(ttx_itiSaccade{session_i,1}(:,3) > sacc_dir_range_left (1) &...
            ttx_itiSaccade{session_i,1}(:,3) < sacc_dir_range_left (2));
        right_saccade_idx = find(ttx_itiSaccade{session_i,1}(:,3) > sacc_dir_range_right (1) |...
            ttx_itiSaccade{session_i,1}(:,3) < sacc_dir_range_right (2));
        
        ttx_iti_saccade.left {session_i} = ttx_itiSaccade{session_i,1}(left_saccade_idx,1);
        ttx_iti_saccade.right {session_i} = ttx_itiSaccade{session_i,1}(right_saccade_idx,1);
        
    end
    
end

%% Extract: Extract the raw neural data to align on the time of the ITI saccade

for session_i = 1:29
    fprintf(' > Extracting EEG on session number %i of 29. \n',session_i);
    % Get session name (to load in relevant file)
    sessionName = FileNames{session_i};
    
    % Clear workspace
    clear trials eventTimes inputLFP cleanLFP alignedLFP filteredLFP betaOutput morletLFP pTrl_burst
    
    % Load raw signal
    inputLFP = load(fullfile(dirs.raw_data,sessionName),...
        'AD01','AD02','AD03','AD04');
    
    % Pre-process & filter analog data (EEG/LFP), and align on event
    filter = 'all'; filterFreq = [1 30];
    
    channel_list = {'AD01','AD02','AD03','AD04'};
    
    for ch_index = 2:3
        
        EEG_signal_npSaccade = [];
        
        channel = channel_list{ch_index};
        
        % Target aligned.
        [~, EEG_signal_npSaccade] = tidy_signal_npSaccade(inputLFP.(channel), params.ephys, filterFreq,...
            ttx_itiSaccade{session_i}, params.alignment);
        
        if ismember(session_i,executiveBeh.nhpSessions.EuSessions) &...
                ch_index == 2; ch_index = 3;
        elseif ismember(session_i, executiveBeh.nhpSessions.EuSessions) &...
                ch_index == 3; ch_index = 2;
        end
        
        EEG_signal.np_saccade{session_i,ch_index} = EEG_signal_npSaccade;

        
    end
    
end


%% Analyse: get ITI eye position figure
% Define example session
session_i = 1;

% Admin: update the user
clc; fprintf('Extracting data from %s... | file %i of %i \n',FileNames{session_i}, session_i, 29);

% Load in the raw data files with eye positions
data_in = load(fullfile(dirs.raw_data,FileNames{session_i}));

% Get event times for secondary saccade
eventTimes = ttx_itiSaccade{session_i};

% Align eye signals on target onset
aligned_eyeX = align_signal(data_in.EyeX_,...
    1:size(eventTimes,1),...
    eventTimes, 2, params.alignment.alignWin);
aligned_eyeY = align_signal(data_in.EyeY_,...
    1:size(eventTimes,1),...
    eventTimes, 2, params.alignment.alignWin);

% Collapse ITI trials for left and rightward saccades
lr_iti_trials = [];
lr_iti_trials = [ttx_iti_saccade.left{session_i};ttx_iti_saccade.right{session_i}];

% For each saccade trial
for trl_i = 1:length(lr_iti_trials)
    
    % Get the RT
    trl_n = lr_iti_trials(trl_i);

    % And get the eye position 50 ms after the saccade started
    x_start(trl_i,1) = aligned_eyeX(trl_n,1000-10)-aligned_eyeX(trl_n,1000-10);
    x_end(trl_i,1) = aligned_eyeX(trl_n,1000+10);
    y_start(trl_i,1) = aligned_eyeY(trl_n,1000-10)-aligned_eyeY(trl_n,1000-10);
    y_end(trl_i,1) = aligned_eyeY(trl_n,1000+10);
end

    
for trl_i = 1:length(eventTimes)
    aligned_eyeX_centered(trl_i,:) = aligned_eyeX(trl_i,:)-nanmean(aligned_eyeX(trl_i,[850:950]));
    aligned_eyeY_centered(trl_i,:) = aligned_eyeY(trl_i,:)-nanmean(aligned_eyeY(trl_i,[850:950]));
end


%% Figure: produce eye position figure
% Define parameters of figure
colormap = cool(2);
time_window = [-100 600];
x_lim_posWindow = [-15 15];
y_lim_posWindow = [-10 10];

% Create figure window
saccade_pos_figure = figure('Renderer', 'painters', 'Position', [100 100 300 600]);
session_i = 1;
% Plot: trial-by-trial x-position
subplot(2,1,1); hold on
plot(aligned_eyeX_centered(ttx_iti_saccade.left{session_i},:),-999:2000,'color',[colormap(1,:) 0.5])
hold on
plot(aligned_eyeX_centered(ttx_iti_saccade.right{session_i},:),-999:2000,'color',[colormap(2,:) 0.5])
ylim(time_window); xlim(x_lim_posWindow); set(gca,'YDir','Reverse')
grid on; box off; set(gca,'TickDir','out')

% Plot: trial-by-trial final saccade position
subplot(2,1,2); hold on
for trl_i = 1:length(lr_iti_trials)
    if x_end(trl_i) > 0
        color_i = [colormap(1,:) 0.5];
    else
        color_i = [colormap(2,:) 0.5];
    end
    
    line([x_start(trl_i,1) x_end(trl_i,1)], [y_start(trl_i,1) y_end(trl_i,1)],'color',color_i);
    scatter(x_end(trl_i,1),y_end(trl_i,1),0.5,'k+');

end
xlim(x_lim_posWindow); ylim(y_lim_posWindow)
grid on; box off; set(gca,'TickDir','out');

%% Export: save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','saccade_pos_figure_iti.pdf');
set(saccade_pos_figure,'PaperSize',[20 10]); %set the paper size to what you want
print(saccade_pos_figure,filename,'-dpdf') % then print it
close(saccade_pos_figure)


%% Analysis: inter-saccade interval

left_iti_saccade_RT = ttx_itiSaccade{session_i}(ttx_iti_saccade.left{session_i},2)-ttx_itiSaccade{session_i}(ttx_iti_saccade.left{session_i},5);
right_iti_saccade_RT = ttx_itiSaccade{session_i}(ttx_iti_saccade.right{session_i},2)-ttx_itiSaccade{session_i}(ttx_iti_saccade.right{session_i},5);

%% Analyse: Extract ERP for left and right ITI saccades
% Initialize the arrays
EEG_saccade_left_iti = [];
EEG_saccade_right_iti = [];

% For each session
for session_i = 1:29
    % Find the lateral channels
    for ch_index = 2:3

        channel = channel_list{ch_index};

        EEG_saccade_left_iti{ch_index}(session_i,:) = nanmean( EEG_signal.np_saccade{session_i,ch_index}(ttx_iti_saccade.left{session_i},:));
        EEG_saccade_right_iti{ch_index}(session_i,:) = nanmean( EEG_signal.np_saccade{session_i,ch_index}(ttx_iti_saccade.right{session_i},:));

    end
end

%% Figure: Saccade-aligned Population EEG for left/right target

for session_i = 1:29
    plot_EEG_left_A(session_i,:)  = EEG_saccade_left_iti{2}(session_i,:);
    plot_EEG_right_A(session_i,:) = EEG_saccade_right_iti{2}(session_i,:);

    plot_EEG_left_B(session_i,:)  = EEG_saccade_left_iti{3}(session_i,:);
    plot_EEG_right_B(session_i,:) = EEG_saccade_right_iti{3}(session_i,:);

end

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);
input_sdf_left_B = num2cell(plot_EEG_left_B, 2);
input_sdf_right_B = num2cell(plot_EEG_right_B, 2);

xlim_input = [-600 200];
ylim_input = [-0.025 0.025];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
iti_saccade_erp(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
iti_saccade_erp(1,1).stat_summary();
iti_saccade_erp(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
iti_saccade_erp(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

iti_saccade_erp(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
iti_saccade_erp(2,1).stat_summary();
iti_saccade_erp(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
iti_saccade_erp(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
iti_saccade_erp(2,1).facet_grid([],monkey_label);

iti_saccade_erp(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
iti_saccade_erp(1,2).stat_summary();
iti_saccade_erp(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
iti_saccade_erp(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

iti_saccade_erp(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
iti_saccade_erp(2,2).stat_summary();
iti_saccade_erp(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
iti_saccade_erp(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
iti_saccade_erp(2,2).facet_grid([],monkey_label);

iti_saccade_erp_out = figure('Renderer', 'painters', 'Position', [100 100 800 400]);
iti_saccade_erp.draw();

%% Export: save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','iti_saccade_erp_out.pdf');
set(iti_saccade_erp_out,'PaperSize',[20 10]); %set the paper size to what you want
print(iti_saccade_erp_out,filename,'-dpdf') % then print it
close(iti_saccade_erp_out)


%% Analyse: Extract mean ERP amplitude for left and right no-stop trials
% Set parameters
analysis_window = [-100:0];

for session_i = 1:29
    mean_EEG_left_AD02(session_i,1)  = nanmean(plot_EEG_left_A(session_i,analysis_window+1000));
    mean_EEG_right_AD02(session_i,1) = nanmean(plot_EEG_right_A(session_i,analysis_window+1000));

    mean_EEG_left_AD03(session_i,1)  = nanmean(plot_EEG_left_B(session_i,analysis_window+1000));
    mean_EEG_right_AD03(session_i,1) = nanmean(plot_EEG_right_B(session_i,analysis_window+1000)); 
end









%% Analysis: 2 x 2 repeated measures ANOVA
anova_table = table...
    (mean_EEG_left_AD02,mean_EEG_right_AD02,mean_EEG_left_AD03,mean_EEG_right_AD03,...
    'VariableNames',{'F3_L','F3_R','F4_L','F4_R'});

anova_table([21, 22, 23],:) = [];

writetable(anova_table,fullfile(dirs.root,'results','eeg_uv_nongoal_outtable.csv'),'WriteRowNames',true)


% electrode x laterality anova in JASP.















