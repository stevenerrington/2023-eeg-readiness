%% Extract: Get slow and fast trials
nostop_speed_trls = get_rtspeed_trls(executiveBeh);

%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
clear EEG_saccade_*

alignment = 'saccade';

% For each session
for session_i = 1:29
    % Find the lateral channels
    for ch_index = 2:3

        channel = channel_list{ch_index};

        % Get the corresponding EEG ERP for left/right, slow and fast
        EEG_saccade_left_fast{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(nostop_speed_trls{session_i}.fast.left,:));
        EEG_saccade_left_slow{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(nostop_speed_trls{session_i}.slow.left,:));
        EEG_saccade_right_fast{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(nostop_speed_trls{session_i}.fast.right,:));
        EEG_saccade_right_slow{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(nostop_speed_trls{session_i}.slow.right,:));

    end
end

for session_i = 1:29
    plot_EEG_AD02_fast(session_i,:)  = EEG_saccade_left_fast{2}(session_i,:);
    plot_EEG_AD02_slow(session_i,:) = EEG_saccade_left_slow{2}(session_i,:);

    plot_EEG_AD03_fast(session_i,:)  = EEG_saccade_right_fast{3}(session_i,:);
    plot_EEG_AD03_slow(session_i,:) = EEG_saccade_right_slow{3}(session_i,:);

end

%% Setup: setup figure parameters and data format
input_sdf_left_fast = num2cell(plot_EEG_AD02_fast, 2);
input_sdf_left_slow = num2cell(plot_EEG_AD02_slow, 2);
input_sdf_right_fast = num2cell(plot_EEG_AD03_fast, 2);
input_sdf_right_slow = num2cell(plot_EEG_AD03_slow, 2);

xlim_input = [-400 200];
ylim_input = [-10 10];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Fast'},length(input_sdf_left_fast),1);repmat({'2_Slow'},length(input_sdf_left_slow),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];


%% Figure: Generate figure
% Produce the figure, collapsed across all monkeys
saccade_erp_speed(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_fast;input_sdf_left_slow],'color',labels_value);
saccade_erp_speed(1,1).stat_summary();
saccade_erp_speed(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_speed(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

saccade_erp_speed(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_fast;input_sdf_left_slow],'color',labels_value);
saccade_erp_speed(2,1).stat_summary();
saccade_erp_speed(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_speed(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
saccade_erp_speed(2,1).facet_grid([],monkey_label);

saccade_erp_speed(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_right_fast;input_sdf_right_slow],'color',labels_value);
saccade_erp_speed(1,2).stat_summary();
saccade_erp_speed(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_speed(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

saccade_erp_speed(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_right_fast;input_sdf_right_slow],'color',labels_value);
saccade_erp_speed(2,2).stat_summary();
saccade_erp_speed(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_speed(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
saccade_erp_speed(2,2).facet_grid([],monkey_label);

saccade_erp_speed_out = figure('Renderer', 'painters', 'Position', [100 100 800 400]);
saccade_erp_speed.draw();


%% Export: Save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_ERP_speed.pdf');
set(saccade_erp_speed_out,'PaperSize',[20 10]); %set the paper size to what you want
print(saccade_erp_speed_out,filename,'-dpdf') % then print it
close(saccade_erp_speed_out)

clear saccade_erp_speed_out input_sdf_* plot_EEG_*

