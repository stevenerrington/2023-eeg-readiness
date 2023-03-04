%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
clear EEG_saccade_*

alignment = 'saccade';

% For each session
for session_i = 1:29
    % Find the lateral channels
    for ch_index = 2:3

        channel = channel_list{ch_index};

        % Get the corresponding EEG ERP for left/right, low and high
        EEG_saccade_left_high{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(executiveBeh.ttx.GO_Left_H{session_i},:));
        EEG_saccade_left_low{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(executiveBeh.ttx.GO_Left_L{session_i},:));
        EEG_saccade_right_high{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(executiveBeh.ttx.GO_Right_H{session_i},:));
        EEG_saccade_right_low{ch_index}(session_i,:) = nanmean( EEG_signal.(alignment){session_i,ch_index}(executiveBeh.ttx.GO_Right_L{session_i},:));

    end
end

for session_i = 1:29
    plot_EEG_AD02_high(session_i,:)  = EEG_saccade_left_high{2}(session_i,:);
    plot_EEG_AD02_low(session_i,:) = EEG_saccade_left_low{2}(session_i,:);

    plot_EEG_AD03_high(session_i,:)  = EEG_saccade_right_high{3}(session_i,:);
    plot_EEG_AD03_low(session_i,:) = EEG_saccade_right_low{3}(session_i,:);

end

%% Setup: setup figure parameters and data format
input_sdf_left_high = num2cell(plot_EEG_AD02_high, 2);
input_sdf_left_low = num2cell(plot_EEG_AD02_low, 2);
input_sdf_right_high = num2cell(plot_EEG_AD03_high, 2);
input_sdf_right_low = num2cell(plot_EEG_AD03_low, 2);

xlim_input = [-600 200];
ylim_input = [-7.5 7.5];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_high'},length(input_sdf_left_high),1);repmat({'2_low'},length(input_sdf_left_low),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];


%% Figure: Generate figure
clear saccade_erp_value

% Produce the figure, collapsed across all monkeys
saccade_erp_value(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_high;input_sdf_left_low],'color',labels_value);
saccade_erp_value(1,1).stat_summary();
saccade_erp_value(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_value(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

saccade_erp_value(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_high;input_sdf_left_low],'color',labels_value);
saccade_erp_value(2,1).stat_summary();
saccade_erp_value(2,1).axe_property('XLim',xlim_input,'YLim',[-10 10]);
saccade_erp_value(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
saccade_erp_value(2,1).facet_grid([],monkey_label);

saccade_erp_value(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_right_high;input_sdf_right_low],'color',labels_value);
saccade_erp_value(1,2).stat_summary();
saccade_erp_value(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
saccade_erp_value(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

saccade_erp_value(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_right_high;input_sdf_right_low],'color',labels_value);
saccade_erp_value(2,2).stat_summary();
saccade_erp_value(2,2).axe_property('XLim',xlim_input,'YLim',[-10 10]);
saccade_erp_value(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
saccade_erp_value(2,2).facet_grid([],monkey_label);

saccade_erp_value_out = figure('Renderer', 'painters', 'Position', [100 100 800 400]);
saccade_erp_value.draw();

%% Export: Save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_ERP_value.pdf');
set(saccade_erp_value_out,'PaperSize',[20 10]); %set the paper size to what you want
print(saccade_erp_value_out,filename,'-dpdf') % then print it
close(saccade_erp_value_out)

clear saccade_erp_value_out input_sdf_* plot_EEG_*


